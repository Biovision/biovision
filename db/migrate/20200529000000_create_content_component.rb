# frozen_string_literal: true

# Create Content component and tables
class CreateContentComponent < ActiveRecord::Migration[6.0]
  def up
    create_component
    create_dynamic_pages unless DynamicPage.table_exists?
    create_navigation_groups unless NavigationGroup.table_exists?
    create_pages_in_groups unless NavigationGroupPage.table_exists?
  end
  
  def down
    BiovisionComponent[Biovision::Components::ContentComponent.slug]&.destroy
    drop_table :navigation_group_pages if NavigationGroupPage.table_exists?
    drop_table :navigation_groups if NavigationGroup.table_exists?
    drop_table :dynamic_pages if DynamicPage.table_exists?
  end

  private

  def create_component
    slug = Biovision::Components::ContentComponent.slug
    BiovisionComponent.create(slug: slug)
  end

  def create_navigation_groups
    create_table :navigation_groups, comment: 'Navigation groups' do |t|
      t.timestamps
      t.integer :dynamic_pages_count, default: 0, null: false
      t.string :slug, null: false
      t.string :name, null: false
    end

    add_index :navigation_groups, :slug, unique: true
  end

  def create_dynamic_pages
    create_table :dynamic_pages, comment: 'Dynamic pages' do |t|
      t.uuid :uuid, null: false
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.references :language, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.boolean :visible, default: true, null: false
      t.string :slug, null: false
      t.string :url, index: true
      t.string :name
      t.text :body, default: '', null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :dynamic_pages, :uuid, unique: true
    add_index :dynamic_pages, :data, using: :gin
  end

  def create_pages_in_groups
    create_table :navigation_group_pages, comment: 'Dynamic pages in navigation groups' do |t|
      t.references :navigation_group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :dynamic_page, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :priority, limit: 2, default: 1, null: false
      t.timestamps
    end
  end
end
