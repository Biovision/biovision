# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Handling component privileges
      module ComponentPrivileges
        # @param [String|Array] privileges
        # @deprecated use #role? or #permit?
        def allow?(*privileges)
          permit?(*privileges)
        end

        # @param [String] action
        # @param [Object] context
        def permit?(action = 'default', context = nil)
          return false if user.nil?

          parts = []
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
          return true if user.super_user? || administrator?

          role = Role[role_name]
          return false if role.nil?

          user.role_ids.include?(role.id)
        end

        # @param [Class|Object] context
        # @return Class
        def model_from_context(context)
          context.is_a?(Class) ? context : context.class
        end

        def create_roles
          slugs = %w[view edit settings.view settings.edit]
          tables = self.class.dependent_models.map(&:table_name)
          tables << 'simple_images' if use_images?
          slugs += crud_role_names(tables)

          slugs.each do |slug|
            Role.create(biovision_component: component, slug: slug)
          end
        end

        # @param [Array] entity_list
        def crud_role_names(entity_list)
          model_roles = %w[list view create edit destroy]
          role_names = []
          entity_list.each do |entity_name|
            role_names += model_roles.map { |role| "#{entity_name}.#{role}" }
          end
          role_names
        end
      end
    end
  end
end
