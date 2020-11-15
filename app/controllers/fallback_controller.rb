# frozen_string_literal: true

# Fallback controller for URL outside router
class FallbackController < ApplicationController
  # get (:slug)
  def show
    url = params[:slug]

    @dynamic_page = DynamicPage.find_by(url: "/#{url}")
    handle_http_404 if @dynamic_page.nil?
  end
end
