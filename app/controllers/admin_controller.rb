# frozen_string_literal: true

# Common administrative controller
class AdminController < ApplicationController
  include RestrictedAccess

  before_action :restrict_access
end
