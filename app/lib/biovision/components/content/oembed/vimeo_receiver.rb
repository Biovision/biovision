# frozen_string_literal: true

module Biovision
  module Components
    module Content
      module Oembed
        # OEmbed receiver for vimeo.com
        class VimeoReceiver < Receiver
          def code_url
            "https://vimeo.com/api/oembed.json?url=#{CGI.escape(@url)}&responsive=true"
          end

          def self.domains
            %w[www.vimeo.com vimeo.com]
          end
        end
      end
    end
  end
end
