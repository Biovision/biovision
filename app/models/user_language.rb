# frozen_string_literal: true

# Language for user
# 
# Attributes:
#   created_at [DateTime]
#   language_id [Language]
#   updated_at [DateTime]
#   user_id [User]
class UserLanguage < ApplicationRecord
  include HasOwner

  belongs_to :user
  belongs_to :language
end
