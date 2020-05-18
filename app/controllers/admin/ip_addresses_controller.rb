# frozen_string_literal: true

# Administrative part of ip_addresses
class Admin::IpAddressesController < AdminController
  # get /admin/ip_addresses
  def index
    @collection = IpAddress.page_for_administration(current_page)
  end

  private

  def component_class
    Biovision::Components::TrackComponent
  end
end
