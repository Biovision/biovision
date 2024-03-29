# frozen_string_literal: true

# Handling components
class Admin::ComponentsController < AdminController
  include ProcessedForms

  # skip_before_action :restrict_access, only: :index
  skip_before_action :verify_authenticity_token, only: :ckeditor

  # get /admin/components
  def index
    @collection = BiovisionComponent.active.list_for_administration
  end

  # get /admin/components/:slug
  def show
    error = 'Viewing component is not allowed'
    handle_http_401(error) unless @handler.permit?('view')
  end

  # get /admin/components/:slug/settings
  def settings
  end

  # patch /admin/components/:slug/settings
  def update_settings
    new_settings = params.dig(:component, :settings).permit!
    @handler.settings = new_settings.to_h
    flash[:success] = t('.success')
    redirect_to(admin_component_settings_path(slug: params[:slug]))
  end

  # patch /admin/components/:slug/parameters
  def update_parameter
    slug = param_from_request(:key, :slug).downcase
    value = param_from_request(:key, :value)

    @handler[slug] = value

    head :no_content
  end

  # delete /admin/components/:slug/parameters/:parameter_slug
  def delete_parameter
    @handler.component.parameters.delete(params[:parameter_slug])
    @handler.component.save

    head :no_content
  end

  # get /admin/components/:slug/images
  def images
    list = SimpleImage.in_component(@handler.component).list_for_administration
    @collection = list.page(current_page)
  end

  # post /admin/components/:slug/images
  def create_image
    if @handler.permit?('simple_images.create')
      @entity = @handler.upload_image(image_parameters)
      if @entity
        render 'image', formats: :json
      else
        form_processed_with_error(:new_image)
      end
    else
      handle_http_401('Uploading images is not allowed for current user')
    end
  end

  # post /admin/components/:slug/files
  def create_file
    if @handler.permit?('uploaded_files.create')
      @entity = @handler.upload_file(file_parameters)
      if @entity
        render 'file', formats: :json
      else
        form_processed_with_error(:new_file)
      end
    else
      handle_http_401('Uploading files is not allowed for current user')
    end
  end

  # post /admin/components/:slug/ckeditor
  def ckeditor
    parameters = {
      image: params[:upload],
      biovision_component: @handler.component
    }.merge(owner_for_entity(true))

    @entity = @handler.upload_image(parameters)

    render json: {
      uploaded: 1,
      fileName: File.basename(@entity.image.path),
      url: @entity.image.medium_url
    }
  end

  private

  def restrict_access
    slug = params[:slug]
    @handler = Biovision::Components::BaseComponent.handler(slug, current_user)
    role = action_name == 'index' ? 'components.view' : role_end_from_action
    role_name = "#{@handler.slug}.#{role}"
    error = t('admin.errors.unauthorized.missing_role', role: role_name)

    handle_http_401(error) unless @handler.permit?(role)
  end

  def image_parameters
    permitted = SimpleImage.entity_parameters
    parameters = params.require(:simple_image).permit(permitted)
    parameters.merge(owner_for_entity(true))
  end

  def file_parameters
    permitted = UploadedFile.entity_parameters
    parameters = params.require(:uploaded_file).permit(permitted)
    parameters.merge(owner_for_entity(true))
  end

  def action_to_role_map
    super.merge(
      %w[images] => 'simple_images.view',
      %w[create_image ckeditor] => 'simple_images.create',
      %w[settings] => 'settings.view',
      %w[update_settings update_parameter delete_parameter] => 'settings.edit',
      %w[show] => 'view'
    )
  end
end
