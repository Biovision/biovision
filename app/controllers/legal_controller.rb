# frozen_string_literal: true

# Legal information
class LegalController < ApplicationController
  # get /tos
  def tos
    @dynamic_page = DynamicPage["tos_#{I18n.locale}"]
  end

  # get /privacy
  def privacy
    @dynamic_page = DynamicPage["privacy_#{I18n.locale}"]
  end
end
