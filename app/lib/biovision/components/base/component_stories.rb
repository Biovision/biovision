# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Methods for handling component stories
      module ComponentStories
        # @param [String] story_slug
        def story_class(story_slug)
          namespace = "biovision/components/#{self.class.slug}"
          handler_name = "#{namespace}/stories/#{story_slug}_story".classify
          handler_name.safe_constantize || Biovision::Stories::ComponentStory
        end

        # @param [String] story_slug
        # @param [ApplicationRecord|nil] entity
        def story(story_slug, entity = nil)
          story_class(story_slug).new(self, entity)
        end

        # @param [String] story_slug
        # @param [Hash] story_parameters
        def perform_story(story_slug, story_parameters)
          story(story_slug).perform(story_parameters)
        end

        # @param [String] story_slug
        # @param [ApplicationRecord|nil] entity
        # @param [Hash] story_parameters
        def entity_story(story_slug, entity, story_parameters)
          story(story_slug, entity).perform(story_parameters)
        end
      end
    end
  end
end
