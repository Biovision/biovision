# frozen_string_literal: true

# Front page
class IndexController < ApplicationController
  # get /
  def index
    @dynamic_page = DynamicPage['frontpage']
  end
end
