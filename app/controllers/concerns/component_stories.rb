# frozen_string_literal: true

# Adds method for working with component stories
module ComponentStories
  extend ActiveSupport::Concern

  def collection_story
    story_parameters = params[:parameters]&.permit!.to_h
    result = component_handler.perform_story(params[:slug], story_parameters)
    render json: { meta: { result: result } }
  end

  def member_story
    story_parameters = params[:parameters]&.permit!.to_h
    result = component_handler.entity_story(params[:slug], @entity, story_parameters)
    render json: { meta: { result: result } }
  end
end
