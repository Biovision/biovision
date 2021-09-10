# frozen_string_literal: true

# Create tables for OEmbed
class CreateOembedReceivers < ActiveRecord::Migration[6.1]
  def change
    # create_table :oembed_receivers, comment: 'Receivers for OEmbed content' do |t|
    #   t.string :slug, null: false, index: true
    # end
    #
    # create_table :oembed_domains, comment: 'Supported domains for OEmbed' do |t|
    #   t.references :oembed_receiver, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    #   t.string :name, null: false, index: true
    # end
    #
    # create_table :oembed_links, comment: 'Embedded links' do |t|
    #   t.string :url, null: false
    #   t.text :code
    #   t.timestamps
    # end
  end
end
