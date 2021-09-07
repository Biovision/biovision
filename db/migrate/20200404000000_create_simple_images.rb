# frozen_string_literal: true

# Create tables for simple images
class CreateSimpleImages < ActiveRecord::Migration[6.0]
  def up
    create_simple_images unless SimpleImage.table_exists?
    create_tags unless SimpleImageTag.table_exists?
    create_tag_links unless SimpleImageTagImage.table_exists?
  end

  def down
    [SimpleImageTagImage, SimpleImageTag, SimpleImage].each do |model|
      drop_table model.table_name if model.table_exists?
    end
  end

  private

  def create_simple_images
    create_table :simple_images, comment: 'Universal simple images' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.uuid :uuid, null: false
      t.timestamps
      t.integer :object_count, default: 0, null: false
      t.string :image
      t.string :image_alt_text, default: '', null: false
      t.string :caption
      t.string :source_name
      t.string :source_link
      t.string :checksum, index: true
      t.jsonb :data, default: {}, null: false
    end

    add_index :simple_images, :uuid, unique: true
    add_index :simple_images, :data, using: :gin
  end

  def create_tags
    create_table :simple_image_tags, comment: 'Tags for simple images' do |t|
      t.string :name, null: false, index: true
      t.timestamps
      t.integer :simple_images_count, default: 0, null: false
    end
  end

  def create_tag_links
    create_table :simple_image_tag_images, comment: 'Links between simple images and tags' do |t|
      t.references :simple_image, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :simple_image_tag, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
