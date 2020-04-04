# frozen_string_literal: true

# Adds ownership to model
module HasOwner
  extend ActiveSupport::Concern

  included do
    scope :owned_by, ->(v) { where(user: v) }
    scope :with_user_id, ->(v) { where(user_id: v) unless v.blank? }
  end

  # @param [User] user
  # @return [Boolean]
  def owned_by?(user)
    !user.nil? && (self.user == user)
  end

  # @return [String]
  def owner_name
    user&.profile_name || I18n.t(:anonymous)
  end
end
