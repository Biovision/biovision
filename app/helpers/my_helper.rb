# frozen_string_literal: true

# Helper methods for user context
module MyHelper
  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def my_edit_icon(entity, options = {})
    title = options.delete(:title) { t(:edit) }
    key = entity.respond_to?(:uuid) ? entity.uuid : entity.id
    path = "/my/#{entity.class.table_name}/#{key}/edit"
    my_icon_with_link('biovision/icons/edit.svg', path, title.to_s, options)
  end

  # @param [ApplicationRecord] entity
  # @param [Hash] options
  def my_destroy_icon(entity, options = {})
    title = options.delete(:title) { t(:edit) }
    key = entity.respond_to?(:uuid) ? entity.uuid : entity.id
    path = "/my/#{entity.class.table_name}/#{key}"
    default = {
      class: 'danger',
      data: { confirm: t(:are_you_sure) },
      method: :delete,
    }
    my_icon_with_link('biovision/icons/destroy.svg', path, title.to_s, default.merge(options))
  end

  # @param [String|ApplicationRecord] path
  # @param [String] title
  # @param [Hash] options
  def my_icon_with_link(source, path, title = '', options = {})
    link_to(image_tag(source, alt: title), path, options)
  end
end