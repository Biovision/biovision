# frozen_string_literal: true

module Biovision
  module Helpers
    # Helper for exporting model data
    class ExportHelper
      EXPORT_DIR = "#{Rails.root}/tmp/export"
      SPECIAL_FIELDS = %w[id agent_id ip_address_id image attachment].freeze

      # @param [Class] model
      def export_model(model)
        puts "Exporting model #{model}..."
        FileUtils.mkdir_p(EXPORT_DIR) unless Dir.exist?(EXPORT_DIR)
        file_name = "#{EXPORT_DIR}/#{model.table_name}.yml"
        File.open(file_name, 'wb') do |file|
          @file = file
          model.order(:id).each do |entity|
            @entity = entity
            export_entity
          end
        end
      end

      private

      def export_entity
        print "\r#{@entity.id}  "
        @file.puts "#{@entity.id}:"
        export_attributes
      end

      def export_attributes
        filtered = @entity.attributes.reject { |a, v| ignored?(a) || v.nil? }
        filtered.each do |attribute, value|
          export_attribute(attribute, value)
        end
        export_track
        export_media('image') if @entity.attributes.key?('image')
        export_media('attachment') if @entity.attributes.key?('attachment')
      end

      # @param [String] attribute
      # @param value
      def export_attribute(attribute, value)
        @file.print "  #{attribute}: "
        if value.is_a?(Hash)
          if value.blank?
            @file.puts '{}'
          else
            @file.puts value.to_yaml.gsub(/\A---|\n\z/, '').gsub("\n", "\n    ")
          end
        else
          @file.puts value.inspect
        end
      end

      def export_track
        return unless @entity.is_a?(HasTrack)

        unless @entity.ip_address.nil?
          @file.puts "  ip_address: #{@entity.ip_address.ip.to_s.inspect}"
        end

        return if @entity.agent.blank?

        @file.puts "  agent: #{@entity.agent.name.inspect}"
      end

      def media_dir
        "#{EXPORT_DIR}/#{@entity.class.table_name}"
      end

      def export_media(type)
        media = @entity.send(type.to_sym)

        return if media.blank?

        media_name = File.basename(media.path)
        dir_name = "#{media_dir}/#{@entity.id}"
        FileUtils.mkdir_p(dir_name) unless Dir.exist?(dir_name)
        FileUtils.copy(media.path, "#{dir_name}/#{media_name}")
        @file.puts "  #{type}: #{media_name.inspect}"
      end

      # @param [String] attribute
      def ignored?(attribute)
        return true if SPECIAL_FIELDS.include?(attribute)

        %w[count cache].each do |ending|
          return true if attribute.end_with?("_#{ending}")
        end

        false
      end
    end
  end
end
