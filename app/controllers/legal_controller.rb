# frozen_string_literal: true

# Legal information
class LegalController < ApplicationController
  # get /tos
  def tos
    @dynamic_page = DynamicPage['tos']
  end

  # get /privacy
  def privacy
    @dynamic_page = DynamicPage['privacy']
  end
end
