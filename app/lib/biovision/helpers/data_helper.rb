# frozen_string_literal: true

module Biovision
  module Helpers
    # Helper for receiving model data in controllers
    class DataHelper
      attr_reader :model_class

      # @param [ApplicationRecord] model_class
      def initialize(model_class)
        @model_class = model_class
      end

      # @param [Integer] page
      # @param [Hash] filters
      def administrative_collection(page = 1, filters = {})
        @filters = filters
        paginates = model_class.respond_to?(:page_for_administration)
        paginates ? administrative_page(page) : administrative_list
      end

      private

      def administrative_list
        if model_class.respond_to?(:filtered)
          model_class.filtered(@filters).list_for_administration
        else
          model_class.list_for_administration
        end
      end

      # @param [Integer] page
      def administrative_page(page)
        reflection = model_class.singleton_method(:page_for_administration)
        if reflection.parameters.include?(%i[key filters])
          model_class.page_for_administration(page, filters: @filters)
        else
          model_class.page_for_administration(page)
        end
      end
    end
  end
end
