# frozen_string_literal: true

# Create tables for access control
class CreateAcl < ActiveRecord::Migration[6.1]
  def up
    create_groups unless Group.table_exists?
    create_roles unless Role.table_exists?
    create_role_groups unless RoleGroup.table_exists?
    create_user_groups unless UserGroup.table_exists?
    create_user_roles unless UserRole.table_exists?

    create_component_roles
  end

  def down
    [UserRole, UserGroup, RoleGroup, Role, Group].each do |model|
      drop_table model.table_name if model.table_exists?
    end
  end

  private

  def create_groups
    create_table :groups, comment: 'ACL groups' do |t|
      t.uuid :uuid, null: false
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :parent_id
      t.integer :user_count, default: 0, null: false
      t.string :slug, index: true, null: false
      t.string :parents_cache, default: '', null: false
      t.integer :children_cache, array: true, default: [], null: false
      t.jsonb :data, default: {}, null: false
    end

    add_foreign_key :groups, :groups, column: :parent_id, on_update: :cascade, on_delete: :cascade
    add_index :groups, :uuid, unique: true
    add_index :groups, :data, using: :gin
  end

  def create_roles
    create_table :roles, comment: 'ACL roles' do |t|
      t.uuid :uuid, null: false
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.integer :user_count, default: 0, null: false
      t.string :slug, index: true, null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :roles, :uuid, unique: true
    add_index :roles, :data, using: :gin
  end

  def create_role_groups
    create_table :role_groups, comment: 'ACL: roles in groups' do |t|
      t.references :role, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
    end
  end

  def create_user_groups
    create_table :user_groups, comment: 'Users in ACL groups' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :group, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
    end
  end

  def create_user_roles
    create_table :user_roles, comment: 'Users with (and without) ACL roles' do |t|
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :role, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.boolean :inclusive, default: true, null: false
      t.timestamps
    end
  end

  def create_component_roles
    BiovisionComponent.pluck(:slug).each do |component|
      next if component == Biovision::Components::BaseComponent.slug

      Biovision::Components::BaseComponent.handler(component).create_roles
    end

    base_component = BiovisionComponent[Biovision::Components::BaseComponent]
    %w[admin components.view].each do |role|
      Role.create(biovision_component: base_component, slug: role)
    end
  end
end
