# frozen_string_literal: true

# Create tables for Users component
class CreateUsersComponent < ActiveRecord::Migration[6.0]
  def up
    create_component
    create_users unless User.table_exists?
    create_tokens unless Token.table_exists?
    create_login_attempts unless LoginAttempt.table_exists?
    create_user_languages unless UserLanguage.table_exists?
    create_component_links unless BiovisionComponentUser.table_exists?
    create_codes unless Code.table_exists?
    create_notifications unless Notification.table_exists?
  end

  def down
    [
      Notification, Code, BiovisionComponentUser, UserLanguage, LoginAttempt,
      Token, User
    ].each do |model|
      drop_table model.table_name if model.table_exists?
    end

    BiovisionComponent[Biovision::Components::UsersComponent]&.destroy
  end

  private

  def create_component
    slug = Biovision::Components::UsersComponent.slug

    settings = {
      registration_open: true,
      email_as_login: false,
      phone_as_login: false,
      confirm_email: false,
      require_email: false,
      confirm_phone: false,
      require_phone: false,
      invite_only: false,
      use_invites: false,
      invite_count: 5,
      bounce_count: 10,
      bounce_timeout: 3,
      use_phone: false
    }

    BiovisionComponent.create(slug: slug, settings: settings)
  end

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

  def create_component_links
    create_table :biovision_component_users, comment: 'Privileges and settings for users in components' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :administrator, default: false, null: false
      t.timestamps
      t.jsonb :data, default: {}, null: false
    end

    add_index :biovision_component_users, :data, using: :gin
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
