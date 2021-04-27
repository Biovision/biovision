# frozen_string_literal: true

# Contact and feedback
class ContactController < ApplicationController
  # get /contact
  def index
    @dynamic_page = DynamicPage['contact']
  end

  # get /contact/feedback
  def feedback
    @dynamic_page = DynamicPage['feedback']
  end

  # post /contact/feedback_messages
  def create_feedback_message
    @entity = FeedbackMessage.new(creation_parameters)
    if params[:agree]
      show_result
    else
      save_entity
    end
  end

  private

  def save_entity
    if @entity.save
      show_result
      FeedbackMailer.new_feedback_request(@entity.id).deliver_later
    else
      redirect_to root_path
    end
  end

  def show_result
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      format.js
    end
  end

  def creation_parameters
    permitted = FeedbackMessage.entity_parameters
    parameters = params.require(:feedback_message).permit(permitted)
    parameters.merge(owner_for_entity(true))
  end
end
