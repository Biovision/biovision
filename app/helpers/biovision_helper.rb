# frozen_string_literal: true

# Helper methods for common cases
module BiovisionHelper
  # @param [ApplicationRecord] entity
  # @param [Biovision::Components::BaseComponent] handler
  # @param [Hash] options
  def admin_entity_link(entity, handler: nil, **options)
    return '∅' if entity.nil?

    component = (handler || component_handler)
    text = options.delete(:text) { component.text_for_link(entity) }

    if handler.nil? || handler.permit?('view', entity)
      href = component.entity_link(entity, :admin)
      link_to(text, href, options)
    else
      text
    end
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def my_entity_link(entity, **options)
    return '∅' if entity.nil?

    handler = Biovision::Components::BaseComponent[]
    text = options.delete(:text) { handler.text_for_link(entity) }
    href = handler.entity_link(entity, :my)

    link_to(text, href, options)
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def entity_link(entity, **options)
    return '' if entity.nil?
    return '' if entity.respond_to?(:visible?) && !entity.visible?

    handler = Biovision::Components::BaseComponent[]
    text = options.delete(:text) { handler.text_for_link(entity) }
    href = handler.entity_link(entity)

    link_to(text, href, options)
  end

  # @param [Hash] options
  def my_home_link(options = {})
    link_to(t('my.index.index.nav_text'), my_path, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def world_icon(path, title = t(:view_as_visitor), options = {})
    if path.is_a? ApplicationRecord
      return '' if path.respond_to?(:visible?) && !path.visible?

      table_name = path.class.table_name
      path = path.respond_to?(:world_url) ? path.world_url : "/#{table_name}/#{path.id}"
    end
    icon_with_link('biovision/icons/world.svg', path, title, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def gear_icon(path, title = t(:view_settings), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}" if path.is_a? ApplicationRecord
    icon_with_link('biovision/icons/gear.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def create_icon(path, title = t(:create), options = {})
    icon_with_link('biovision/icons/create.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def back_icon(path, title = t(:back), options = {})
    icon_with_link('biovision/icons/back.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def return_icon(path, title = t(:back), options = {})
    icon_with_link('biovision/icons/return.svg', path, title, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def edit_icon(path, title = t(:edit), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}/edit" if path.is_a? ApplicationRecord
    icon_with_link('biovision/icons/edit.svg', path, title, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def destroy_icon(path, title = t(:delete), options = {})
    path = "/admin/#{path.class.table_name}/#{path.id}" if path.is_a? ApplicationRecord
    default = {
      class: 'danger',
      data: { confirm: t(:are_you_sure) },
      method: :delete,
    }
    icon_with_link('biovision/icons/destroy.svg', path, title, default.merge(options))
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def icon_with_link(source, path, title, options = {})
    link_to(image_tag(source, alt: title), path, options)
  end

  # @param [String] path
  # @param [String] text
  def create_button(path, text = t(:create))
    link_to(text, path, class: 'button button-save')
  end

  # @param [String|ApplicationRecord] path
  # @param [String] text
  def edit_button(path, text = t(:edit))
    path = "/admin/#{path.class.table_name}/#{path.id}/edit" if path.is_a? ApplicationRecord
    link_to(text, path, class: 'button button-secondary')
  end

  # @param [String|ApplicationRecord] path
  # @param [String] text
  def destroy_button(path, text = t(:delete))
    path = "/admin/#{path.class.table_name}/#{path.id}" if path.is_a? ApplicationRecord
    options = {
      class: 'button button-danger',
      data: { confirm: t(:are_you_sure) },
      method: :delete
    }
    link_to(text, path, options)
  end

  # @param [String] phone
  # @param [Hash] options
  def phone_link(phone, options = {})
    link_to(phone, "tel:#{phone.gsub(/[^+0-9]/, '')}", options)
  end

  # @param [String] email
  # @param [Hash] options
  def email_link(email, options = {})
    link_to(email, "mailto:#{email}", options)
  end

  # @param [ApplicationRecord] entity
  # @deprecated use #entity_priority_icons
  def admin_priority_icons(entity)
    render(partial: 'shared/admin/priority', locals: { entity: entity })
  end

  # @param [ApplicationRecord] entity
  # @deprecated use #entity_toggle
  def admin_toggle_block(entity)
    render(partial: 'shared/admin/toggle', locals: { entity: entity })
  end
end
