# frozen_string_literal: true

module Biovision
  module Components
    module Content
      module Oembed
        # OEmbed receiver for YouTube
        class YoutubeReceiver < Receiver
          def code_url
            "https://www.youtube.com/oembed?url=#{CGI.escape(@url)}&format=json"
          end

          def self.domains
            %w[www.youtube.com youtube.com youtu.be]
          end
        end
      end
    end
  end
end
