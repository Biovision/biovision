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
          prefix = %i[admin my].include?(scope.to_sym) ? scope : 'world'
          message = "#{prefix}_url".to_sym
          if entity.respond_to?(message)
            entity.send(message)
          else
            rest_entity_link(entity, scope.to_sym)
          end
        end

        # @param [ApplicationRecord] entity
        # @param [Symbol] scope
        def rest_entity_link(entity, scope)
          collection = "/#{scope}/#{entity.class.table_name}"
          if entity.attributes.key?('uuid') && scope != :admin
            "#{collection}/#{entity.uuid}"
          else
            "#{collection}/#{entity.id}"
          end
        end
      end
    end
  end
end
