# frozen_string_literal: true

# Receiving oembed data by URLs
class OembedController < ApplicationController
  # get /oembed?url=
  def code
    url = param_from_request(:url)
    receiver = Biovision::Components::Content::Oembed::Receiver[url]

    render json: { meta: { code: receiver.code } }
  end
end
