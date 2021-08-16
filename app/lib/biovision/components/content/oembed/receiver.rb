# frozen_string_literal: true

# Receiver for OEmbed-wrapped content
module Biovision
  module Components
    module Content
      module Oembed
        # Default receiver for embedded media
        class Receiver
          PATTERN = %r{<oembed url="([^"]+)"></oembed>}

          # @param [String] url
          def initialize(url = '')
            @url = url
          end

          # @param [String] url
          def self.[](url)
            host = URI.parse(url).host
            slug = OembedDomain[host]&.receiver_slug
            receiver_path = "biovision/components/content/oembed/#{slug}_receiver"
            receiver_class = receiver_path.classify.safe_constantize

            receiver_class.nil? ? new(url) : receiver_class.new(url)
          end

          # @param [String] text
          def self.convert(text)
            text.gsub(PATTERN) do |fragment|
              url = fragment.match(PATTERN)[1].to_s
              return '' if url.blank?

              receiver = self[url]
              receiver.code
            end
          end

          def self.slug
            to_s.demodulize.to_s.underscore.gsub('_receiver', '')
          end

          def self.domains
            %w[]
          end

          def self.seed
            receiver_entity = OembedReceiver.find_or_create_by(slug: slug)
            domains.each do |domain|
              receiver_entity.oembed_domains.create(name: domain)
            end
          end

          def code
            @link = OembedLink[@url]
            @link.code || receive_and_update
          end

          def fallback
            attributes = %(rel="external nofollow noreferrer" target="_blank")
            %(<a href="#{@url}" #{attributes}>#{URI.parse(@url).host}</a>)
          end

          private

          def receive_and_update
            code = receive(code_url)
            @link.code = code
            @link.save

            code
          end

          # @param [String] embed_url
          def receive(embed_url)
            response = RestClient.get(embed_url)
            parse(response.body)
          rescue RestClient::Exception => e
            Rails.logger.warn("Cannot receive data for #{embed_url}: #{e}")
            fallback
          end

          # @param [String] response
          def parse(response)
            json = JSON.parse(response)
            json['html'] || fallback
          rescue JSON::ParserError => e
            Rails.logger.warn("Cannot parse response #{response}: #{e}")
            fallback
          end

          def code_url
            "https://#{@host}/oembed?url=#{CGI.escape(@url)}&format=json"
          end
        end
      end
    end
  end
end
