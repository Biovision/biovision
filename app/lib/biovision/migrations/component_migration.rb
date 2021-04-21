# frozen_string_literal: true

module Biovision
  module Migrations
    # Mix-ins for repeated component migration parts
    module ComponentMigration
      # Component class
      def component
        @component ||= find_component
      end

      # Create component tables and roles
      #
      # Creates new BiovisionComponent
      # For each dependent model, calls "create_<table_name>" method
      # Creates roles for new component
      def up
        component.create
        component.dependent_models.each do |model|
          next if model.table_exists?

          message = "create_#{model.table_name}".to_sym
          send(message) if respond_to?(message, true)
        end
        component[nil].create_roles
      end

      # Drops tables for each dependent model
      # Removes BiovisionComponent
      def down
        component.dependent_models.reverse.each do |model|
          drop_table model.table_name if model.table_exists?
        end
        BiovisionComponent[component]&.destroy
      end

      private

      # Find component class by migration name
      #
      # Method relies on naming like Create<:CamelCaseSlug>Component
      #
      # Example:
      #   - Migration class is named CreateFooBarComponent
      #   - Component slug is "foo_bar"
      #   - Use base component handler to get "FooBarComponent" class
      def find_component
        migration = name.to_s.demodulize.to_s.underscore
        slug = migration.gsub(/\Acreate_/, '').gsub(/_component\z/, '')
        Biovision::Components::BaseComponent.handler_class(slug)
      end
    end
  end
end
