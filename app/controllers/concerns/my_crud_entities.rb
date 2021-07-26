# frozen_string_literal: true

# Adds methods for CRUD in My namespace
module MyCrudEntities
  extend ActiveSupport::Concern

  # get [scope]/[table_name]/search?q=
  def search
    q = param_from_request(:q)
    @collection = model_class.search(q).list_for_owner(current_user).page(current_page)
  end

  # get [scope]/[table_name]
  def index
    @filter = params[:filter]&.permit!.to_h
    data_helper = Biovision::Helpers::DataHelper.new(model_class, @filter)
    @collection = data_helper.personal_collection(current_user, current_page)
  end

  # get [scope]/[table_name]/:id
  def show
  end

  # post [scope]/[table_name]/check
  def check
    @entity = model_class.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get [scope]/[table_name]/new
  def new
    @entity = model_class.new
    render view_for_new
  end

  # post [scope]/[table_name]
  def create
    @entity = component_handler.new_entity(model_class, creation_parameters)
    apply_meta if @entity.respond_to?(:meta=)
    if @entity.save
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_new)
    end
  end

  # get [scope]/[table_name]/:id/edit
  def edit
    render view_for_edit
  end

  # patch [scope]/[table_name]/:id
  def update
    apply_meta if @entity.respond_to?(:meta=)

    if component_handler.update_entity(@entity, entity_parameters)
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_edit)
    end
  end

  # delete [scope]/[table_name]/:id
  def destroy
    flash[:notice] = t('.success') if @entity.destroy
    redirect_to path_after_destroy
  end

  private

  def view_for_new
    default_view = "#{controller_path}/new"
    lookup_context.exists?(default_view) ? default_view : 'shared/my/entity/new'
  end

  def view_for_edit
    default_view = "#{controller_path}/edit"
    lookup_context.exists?(default_view) ? default_view : 'shared/my/entity/edit'
  end

  def model_class
    @model_class ||= controller_name.classify.constantize
  end

  def model_key
    model_class.model_name.to_s.underscore
  end

  def path_after_save
    if @entity.respond_to?(:my_url)
      @entity.my_url
    else
      scope = self.class.module_parent.to_s.downcase
      prefix = scope.blank? ? '' : "/#{scope}"
      key = model_class.column_names.include?('uuid') ? @entity.uuid : @entity.id
      "#{prefix}/#{model_class.table_name}/#{key}"
    end
  end

  def path_after_destroy
    scope = self.class.module_parent.to_s.downcase
    prefix = scope.blank? ? '' : "/#{scope}"
    "#{prefix}/#{model_class.table_name}"
  end

  def set_entity
    id = params[:id].to_s
    has_uuid = model_class.column_names.include?('uuid')
    key = id.include?('-') && has_uuid ? :uuid : :id
    @entity = model_class.owned_by(current_user).find_by(key => params[:id])
    handle_http_404("Cannot find #{model_class.model_name}") if @entity.nil?
  end

  def creation_parameters
    if model_class.respond_to?(:creation_parameters)
      explicit_creation_parameters
    else
      implicit_creation_parameters
    end
  end

  def explicit_creation_parameters
    permitted = model_class.creation_parameters
    parameters = params.require(model_key).permit(permitted)
    parameters.merge!(tracking_for_entity) if model_class.include?(HasTrack)
    parameters.merge(owner_for_entity)
  end

  def implicit_creation_parameters
    parameters = entity_parameters
    parameters.merge!(tracking_for_entity) if model_class.include?(HasTrack)
    parameters.merge(owner_for_entity)
  end

  def entity_parameters
    permitted = model_class.entity_parameters
    params.require(model_key).permit(permitted)
  end

  def apply_meta
    new_data = params[:meta].permit!
    @entity.meta = new_data
  end
end
