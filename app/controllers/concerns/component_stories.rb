# frozen_string_literal: true

# Adds method for working with component stories
module ComponentStories
  extend ActiveSupport::Concern

  # Perform story
  #
  # Parameters:
  #   slug: story slug app/lib/biovision/components/.../stories/<slug>_story.rb
  #   entity_id: optional parameter for setting entity context
  #
  # post [...]/stories/:slug
  def story
    story_parameters = params[:parameters]&.permit!.to_h
    entity_id = param_from_request(:entity_id)
    story_handler = component_handler.story(params[:slug], entity_id)
    result = story_handler.perform(story_parameters)

    render json: { meta: { result: result } }
  end
end
