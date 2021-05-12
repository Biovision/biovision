# frozen_string_literal: true

module Biovision
  module Components
    # Base biovision component
    class BaseComponent
      extend Base::ComponentSettings
      include Base::ComponentPrivileges
      include Base::ComponentParameters
      include Base::EntityLinks

      attr_reader :component, :slug, :name, :user, :user_link

      # @param [BiovisionComponent] component
      # @param [User|nil] user
      def initialize(component, user = nil)
        @component = component
        @slug = component&.slug || 'base'
        self.user = user

        @name = I18n.t("biovision.components.#{@slug}.name", default: @slug)
      end

      # Receive component-specific handler by component slug
      #
      # @param [String|BiovisionComponent] input
      # @param [User] user
      # @return [BaseComponent]
      def self.handler(input, user = nil)
        type = input.is_a?(String) ? input : input&.slug
        handler_class(type)[user]
      end

      def self.slug
        to_s.demodulize.to_s.underscore.gsub('_component', '')
      end

      def self.active?
        BiovisionComponent[slug]&.active?
      end

      # Receive component-specific handler by class name for component.
      #
      # e.g.: Biovision::Components::UsersComponent[user]
      #
      # @param [User] user
      def self.[](user = nil)
        new(BiovisionComponent[slug], user)
      end

      # @param [String] slug
      def self.handler_class(slug)
        handler_name = "biovision/components/#{slug}_component".classify
        handler_name.safe_constantize || BaseComponent
      end

      # Model list for automatic role creation
      def self.dependent_models
        []
      end

      def self.create
        BiovisionComponent.create(slug: slug, settings: default_settings)
      end

      # @param [ApplicationRecord] entity
      # @param [Symbol|nil] scope
      # @param [Hash] options
      def self.form_options(entity, scope = :admin, options = {})
        table_name = entity.class.table_name
        prefix = scope.nil? ? '' : "/#{scope}"
        {
          model: scope.nil? ? entity : [scope, entity],
          id: "#{entity.class.to_s.underscore}-form",
          data: { check_url: "#{prefix}/#{table_name}/check" }
        }.merge(options)
      end

      # @param [User] user
      def user=(user)
        @user = user

        if @user.nil?
          @user_link = nil
        else
          criteria = { biovision_component: @component, user: user }
          @user_link = BiovisionComponentUser.find_by(criteria)
        end
      end

      def user_link!(force_create = false)
        if @user_link.nil?
          criteria = { biovision_component: @component, user: user }
          @user_link = BiovisionComponentUser.new(criteria)
          @user_link.save if force_create
        end

        @user_link
      end

      def use_settings?
        use_parameters? || @component.settings.any?
      end

      # @param [Hash] data
      def settings=(data)
        @component.settings.merge!(self.class.normalize_settings(data))
        @component.save!
      end

      def settings
        @component.settings
      end

      # @param [String] name
      # @param [Integer] quantity
      def register_metric(name, quantity = 1)
        metric = Metric.find_by(name: name)
        if metric.nil?
          attributes = {
            biovision_component: @component,
            name: name,
            incremental: !name.end_with?('.hit')
          }
          metric = Metric.create(attributes)
        end

        metric << quantity
      end

      # @param [User] user
      # @param [String] code_type
      # @param [Integer] quantity
      def find_or_create_code(user, code_type, quantity = 1)
        @component.find_or_create_code(user, code_type, quantity)
      end

      # @param [String|Symbol] key
      # @param default_value
      def data_value(key, default_value = '')
        data = user.component_data(slug)
        data.key?(key.to_s) ? data[key.to_s] : default_value
      end

      # @param [String|Symbol] key
      # @param new_value
      def update_data_value(key, new_value)
        data = user.component_data(slug)
        data[key.to_s] = new_value
        user.new_component_data(data)
      end

      # @param [ApplicationRecord] entity
      # @param [Hash] new_attributes
      def update_entity(entity, new_attributes)
        entity.update(new_attributes)
      end

      # @param [Class] model_class
      # @param [Hash] parameters
      def new_entity(model_class, parameters)
        model_class.new(parameters)
      end
    end
  end
end
