# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Handling component privileges
      module ComponentPrivileges
        # @param [String] action
        # @param [Object] context
        def permit?(action = 'default', context = nil)
          return false if user.nil?

          parts = [slug]
          model = model_from_context(context)
          parts << model.table_name if model.respond_to?(:table_name)
          parts << action
          owner?(context) || role?(parts.join('.'))
        end

        # @param [ApplicationRecord|nil] entity
        def owner?(entity)
          return false unless entity.respond_to?(:owned_by?)

          entity.owned_by?(user)
        end

        # @param [String] role_name
        def role?(role_name)
          return false if user.nil?
          return true if user.super_user?

          role = Role[role_name]
          return false if role.nil?

          user.role_ids.include?(role.id)
        end

        # @param [Class|Object] context
        # @return Class
        def model_from_context(context)
          context.is_a?(Class) ? context : context.class
        end

        def crud_table_names
          tables = self.class.dependent_models.map(&:table_name)
          tables << 'simple_images' if use_images?
          tables
        end

        def role_tree
          tree = { nil => %w[default view] }
          tree['settings'] = %w[view edit] if use_settings?
          crud_table_names.each do |table_name|
            tree[table_name] = %w[view edit]
          end
          tree
        end

        def create_roles
          role_tree.each do |prefix, postfixes|
            postfixes.each do |postfix|
              slug = prefix.blank? ? postfix : "#{prefix}.#{postfix}"
              Role.create(biovision_component: component, slug: slug)
            end
          end
        end

        def administrative_parts
          self.class.dependent_models.map(&:table_name)
        end
      end
    end
  end
end
