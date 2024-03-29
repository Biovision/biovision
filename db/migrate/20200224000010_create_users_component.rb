# frozen_string_literal: true

# Create tables for Users component
class CreateUsersComponent < ActiveRecord::Migration[6.1]
  include Biovision::Migrations::ComponentMigration

  def up
    component.create
    component.dependent_models.each do |model|
      next if model.table_exists?

      message = "create_#{model.table_name}".to_sym
      send(message) if respond_to?(message, true)
    end
  end

  private

  def create_users
    create_table :users, comment: 'Users' do |t|
      t.uuid :uuid, null: false
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.integer :primary_id, index: true
      t.integer :inviter_id, index: true
      t.boolean :super_user, default: false, null: false
      t.boolean :banned, default: false, null: false
      t.boolean :bot, default: false, null: false
      t.boolean :deleted, default: false, null: false
      t.boolean :email_confirmed, default: false, null: false
      t.boolean :phone_confirmed, default: false, null: false
      t.boolean :allow_mail, default: true, null: false
      t.datetime :last_seen
      t.date :birthday
      t.string :slug, null: false
      t.string :screen_name, null: false
      t.string :password_digest, null: false
      t.string :email, index: true
      t.string :phone, index: true
      t.string :image
      t.string :notice
      t.string :referral_link
      t.jsonb :data, default: {}, null: false
      t.jsonb :profile, default: {}, null: false
    end

    add_foreign_key :users, :users, column: :inviter_id, on_update: :cascade, on_delete: :nullify
    add_foreign_key :users, :users, column: :primary_id, on_update: :cascade, on_delete: :nullify

    add_index :users, :uuid, unique: true
    add_index :users, :slug, unique: true
    add_index :users, :data, using: :gin
    add_index :users, :profile, using: :gin
    add_index :users, :referral_link, unique: true
  end

  def create_tokens
    create_table :tokens, comment: 'Authentication tokens' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.datetime :last_used, index: true
      t.boolean :active, default: true, null: false
      t.string :token, null: false
    end

    add_index :tokens, :token, unique: true
  end

  def create_login_attempts
    create_table :login_attempts, comment: 'Failed login attempts' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.string :password, default: '', null: false
    end
  end

  def create_user_languages
    create_table :user_languages, comment: 'Languages for users' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :language, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end

  def create_codes
    create_table :codes, comment: 'Codes for different purposes' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.integer :quantity, default: 1, null: false
      t.string :body, index: true, null: false
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :codes, :data, using: :gin
  end

  def create_notifications
    create_table :notifications, comment: 'Component notifications for users' do |t|
      t.uuid :uuid, null: false
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :email_sent, default: false, null: false
      t.boolean :read, default: false, null: false
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :notifications, :uuid, unique: true
    add_index :notifications, :data, using: :gin
  end
end
