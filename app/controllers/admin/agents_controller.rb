# frozen_string_literal: true

# Administrative part of agents
class Admin::AgentsController < AdminController
  # get /admin/agents
  def index
    @collection = Agent.page_for_administration(current_page)
  end

  private

  def component_class
    Biovision::Components::TrackComponent
  end
end
