# frozen_string_literal: true

# User data in biovision component
# 
# Attributes:
#   administrator [boolean]
#   biovision_component_id [BiovisionComponent]
#   created_at [DateTime]
#   data [jsonb]
#   updated_at [DateTime]
#   user_id [User]
class BiovisionComponentUser < ApplicationRecord
  include HasOwner

  belongs_to :biovision_component
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :biovision_component_id

  scope :recent, -> { order('updated_at desc') }
end
