# frozen_string_literal: true

# Create tables for storing uploaded files
class CreateUploadedFiles < ActiveRecord::Migration[6.1]
  def up
    create_uploaded_files unless UploadedFile.table_exists?
    create_uploaded_file_tags unless UploadedFileTag.table_exists?
    create_uploaded_file_tag_files unless UploadedFileTagFile.table_exists?
  end

  def down
    [UploadedFileTagFile, UploadedFileTag, UploadedFile].each do |model|
      drop_table model.table_name if model.table_exists?
    end
  end

  private

  def create_uploaded_files
    create_table :uploaded_files, comment: 'Uploaded files' do |t|
      t.uuid :uuid, null: false
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :agent, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :ip_address, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.integer :object_count, default: 0, null: false
      t.timestamps
      t.string :attachment
      t.string :description
      t.string :checksum, index: true
      t.jsonb :data, default: {}, null: false
    end

    add_index :uploaded_files, :uuid, unique: true
    add_index :uploaded_files, :data, using: :gin
  end

  def create_uploaded_file_tags
    create_table :uploaded_file_tags, comment: 'Tags for uploaded files' do |t|
      t.string :name, null: false, index: true
      t.integer :uploaded_files_count, default: 0, null: false
      t.timestamps
    end
  end

  def create_uploaded_file_tag_files
    create_table :uploaded_file_tag_files, comment: 'Links between uploaded files and tags' do |t|
      t.references :uploaded_file_tag, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :uploaded_file, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end
end
