# frozen_string_literal: true

module Biovision
  module Components
    module Content
      module Oembed
        # OEmbed receiver for Twitter
        class TwitterReceiver < Receiver
          def code_url
            "https://publish.twitter.com/oembed?url=#{CGI.escape(@url)}"
          end

          def self.domains
            %w[twitter.com www.twitter.com]
          end
        end
      end
    end
  end
end
