# frozen_string_literal: true

# Send phone confirmation code via SMS gateway
class SendPhoneConfirmationJob < ApplicationJob
  queue_as :default

  # @param [Integer] id
  def perform(id)
    code = Code.find_by(id: id)

    return if code.nil?

    # To be implemented: use actual gateway
    code.user.phone
  end
end
