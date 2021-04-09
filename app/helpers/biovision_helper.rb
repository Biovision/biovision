# frozen_string_literal: true

# Helper methods for common cases
module BiovisionHelper
  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def admin_entity_link(entity, text = nil, options = {})
    return '∅' if entity.nil?

    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = if entity.respond_to?(:admin_url)
             entity.admin_url
           else
             "/admin/#{entity.class.table_name}/#{entity.id}"
           end

    link_to(text, href, options)
  end

  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def my_entity_link(entity, text = nil, options = {})
    return '∅' if entity.nil?

    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = if entity.respond_to?(:my_url)
             entity.my_url
           else
             "/my/#{entity.class.table_name}/#{entity.id}"
           end

    link_to(text, href, options)
  end

  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def entity_link(entity, text = nil, options = {})
    return '' if entity.nil?

    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = if entity.respond_to?(:world_url)
             entity.world_url
           else
             "/#{entity.class.table_name}/#{entity.id}"
           end

    link_to(text, href, options)
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def world_icon(path, title = t(:view_as_visitor), options = {})
    if path.is_a? ApplicationRecord
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
end
