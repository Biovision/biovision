# frozen_string_literal: true

# Create entry and tables for track component
class CreateTrackComponent < ActiveRecord::Migration[6.0]
  def up
    create_component
    create_browsers unless Browser.table_exists?
    create_agents unless Agent.table_exists?
    create_ip_addresses unless IpAddress.table_exists?
  end

  def down
    drop_table :ip_addresses if IpAddress.table_exists?
    drop_table :agents if Agent.table_exists?
    drop_table :browsers if Browser.table_exists?
  end

  private

  def create_component
    BiovisionComponent.create(slug: Biovision::Components::TrackComponent.slug)
  end

  def create_browsers
    create_table :browsers, comment: 'Browsers' do |t|
      t.boolean :mobile, default: false, null: false
      t.boolean :banned, default: false, null: false
      t.timestamps
      t.integer :agents_count, default: 0, null: false
      t.string :name, null: false
      t.string :version, null: false
    end

    add_index :browsers, %i[name version], unique: true
  end

  def create_agents
    create_table :agents, comment: 'User agents' do |t|
      t.references :browser, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.integer :object_count, default: 0, index: true, null: false
      t.boolean :banned, default: false, null: false
      t.timestamps
      t.string :name, null: false
    end

    add_index :agents, :name, unique: true
  end

  def create_ip_addresses
    create_table :ip_addresses, comment: 'IP addresses' do |t|
      t.inet :ip, null: false
      t.integer :object_count, default: 0, index: true, null: false
      t.boolean :banned, default: false, null: false
      t.timestamps
    end

    add_index :ip_address, :ip, unique: true
  end
end
