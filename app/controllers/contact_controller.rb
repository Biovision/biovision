# frozen_string_literal: true

# Contact and feedback
class ContactController < ApplicationController
  # get /contact
  def index
    @dynamic_page = DynamicPage['contact']
  end

  # post /contact/feedback_messages
  def create_feedback_message

  end
end
