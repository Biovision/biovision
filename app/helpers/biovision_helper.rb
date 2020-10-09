# frozen_string_literal: true

# Helper methods for common cases
module BiovisionHelper
  # @param [ApplicationRecord] entity
  # @param [String] text
  # @param [Hash] options
  def admin_entity_link(entity, text = nil, options = {})
    if text.nil?
      text = entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
    end

    href = "/admin/#{entity.class.table_name}/#{entity.id}"
    link_to(text, href, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def world_icon(path, title = t(:view_as_visitor), options = {})
    icon_with_link('biovision/icons/world.svg', path, title, options)
  end

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def gear_icon(path, title = t(:view_settings), options = {})
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

  # @param [String] path
  # @param [String] title
  # @param [Hash] options
  def edit_icon(path, title = t(:edit), options = {})
    icon_with_link('biovision/icons/edit.svg', path, title, options)
  end

  # @param [ApplicationRecord] entity
  # @param [String] title
  # @param [Hash] options
  def destroy_icon(entity, title = t(:delete), options = {})
    default = {
      method: :delete,
      data: { confirm: t(:are_you_sure)}
    }
    icon_with_link('biovision/icons/destroy.svg', entity, title, default.merge(options))
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
    link_to(text, path, class: 'button-create')
  end

  # @param [String] path
  # @param [String] text
  def edit_button(path, text = t(:edit))
    link_to(text, path, class: 'button-edit')
  end

  # @param [String] path
  # @param [String] text
  def destroy_button(path, text = t(:delete))
    link_to(text, path, class: 'button-destroy')
  end
end
