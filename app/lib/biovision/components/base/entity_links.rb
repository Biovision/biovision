# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Links for entities in context of current user
      module EntityLinks
        # @param [ApplicationRecord] entity
        def text_for_link(entity)
          entity.respond_to?(:text_for_link) ? entity.text_for_link : entity.id
        end

        # @param [ApplicationRecord] entity
        # @param [Symbol|String] scope
        def entity_link(entity, scope = '')
          default = "#{scope}/#{entity.class.table_name}/#{entity.id}"
          prefix = %i[admin my].include?(scope.to_sym) ? scope : 'world'
          message = "#{prefix}_url".to_sym
          entity.respond_to?(message) ? entity.send(message) : "/#{default}"
        end
      end
    end
  end
end
