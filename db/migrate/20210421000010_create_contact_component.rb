# frozen_string_literal: true

# Create tables for contact component
class CreateContactComponent < ActiveRecord::Migration[6.1]
  include Biovision::Migrations::ComponentMigration

  private

  def create_feedback_messages
    create_table :feedback_messages, comment: 'Feedback messages from visitors' do |t|
      t.uuid :uuid, null: false
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.boolean :visible, default: false, null: false
      t.boolean :processed, default: false, null: false
      t.string :attachment
      t.string :name
      t.string :email
      t.string :phone
      t.text :comment
      t.jsonb :data, default: {}, null: false
    end

    add_index :feedback_messages, :uuid, unique: true
    add_index :feedback_messages, :data, using: :gin
  end

  def create_feedback_responses
    create_table :feedback_responses, comment: 'Responses to feedback messages' do |t|
      t.uuid :uuid, null: false
      t.references :feedback_message, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.text :body
      t.jsonb :data, default: {}, null: false
    end

    add_index :feedback_responses, :uuid, unique: true
    add_index :feedback_responses, :data, using: :gin
  end

  def create_contact_types
    create_table :contact_types, comment: 'Types of contact methods' do |t|
      t.string :slug, null: false
    end

    add_index :contact_types, :slug, unique: true

    %w[email phone address].each { |slug| ContactType.create(slug: slug) }
  end

  def create_contact_methods
    create_table :contact_methods, comment: 'Contact methods for visitors' do |t|
      t.uuid :uuid, null: false
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :contact_type, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.string :name
      t.string :value
      t.jsonb :data, default: {}, null: false
    end

    add_index :contact_methods, :uuid, unique: true
    add_index :contact_methods, :data, using: :gin
  end
end
