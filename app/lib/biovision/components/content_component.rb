# frozen_string_literal: true

module Biovision
  module Components
    # Content
    class ContentComponent < BaseComponent
      def self.dependent_models
        [DynamicPage, NavigationGroup, NavigationGroupPage, DynamicBlock]
      end

      def use_parameters?
        true
      end

      def use_images?
        true
      end

      def crud_table_names
        super - %w[navigation_group_pages]
      end

      def administrative_parts
        %w[navigation_groups dynamic_blocks dynamic_pages]
      end

      def navigation
        @navigation ||= prepare_navigation
      end

      private

      def prepare_navigation
        result = {}
        NavigationGroup.connection.execute(grouped_links_query).each do |row|
          result[row['slug']] = [] unless result.key?(row['slug'])
          result[row['slug']] << { text: row['name'], url: row['url'] }
        end
        result
      end

      def grouped_links_query
        <<~SQL
          select g.slug, p.name, p.url
          from "#{NavigationGroupPage.table_name}" gp
          join "#{NavigationGroup.table_name}" g on gp.navigation_group_id = g.id
          join "#{DynamicPage.table_name}" p on gp.dynamic_page_id = p.id
          where p.visible = true
          order by g.slug asc, gp.priority asc
        SQL
      end
    end
  end
end
