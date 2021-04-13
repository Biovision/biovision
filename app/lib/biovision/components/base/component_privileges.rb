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

          Array(user.data['role_cache']).include?(role.id)
        end

        # @param [Class|Object] context
        # @return Class
        def model_from_context(context)
          context.is_a?(Class) ? context : context.class
        end

        def create_roles
          slugs = %w[view edit]
          model_roles = %w[list view create edit destroy]
          model_roles.each { |role| slugs << "simple_images.#{role}" }
          self.class.dependent_models.each do |model|
            model_roles.each { |role| slugs << "#{model.table_name}.#{role}" }
          end

          slugs.each do |slug|
            Role.create(biovision_component: component, slug: slug)
          end
        end
      end
    end
  end
end
