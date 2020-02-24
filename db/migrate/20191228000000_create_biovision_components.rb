# frozen_string_literal: true

# Create tables for Biovision components and metrics
class CreateBiovisionComponents < ActiveRecord::Migration[6.0]
  def up
    create_components unless BiovisionComponent.table_exists?
    create_metrics unless Metric.table_exists?
    create_metric_values unless MetricValue.table_exists?
    create_languages unless Language.table_exists?
  end

  def down
    drop_table :languages if Language.table_exists?
    drop_table :metric_values if MetricValue.table_exists?
    drop_table :metrics if Metric.table_exists?
    drop_table :biovision_components if BiovisionComponent.table_exists?
  end

  private

  def create_components
    create_table :biovision_components, comment: 'Biovision CMS components' do |t|
      t.integer :priority, limit: 2, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.timestamps
      t.string :slug, null: false
      t.jsonb :settings, default: {}, null: false
      t.jsonb :parameters, default: {}, null: false
    end

    add_index :biovision_components, :slug, unique: true
  end

  def create_metrics
    create_table :metrics, comment: 'Component metrics' do |t|
      t.references :biovision_component, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamps
      t.boolean :incremental, default: false, null: false
      t.boolean :start_with_zero, default: true, null: false
      t.boolean :show_on_dashboard, default: true, null: false
      t.integer :default_period, limit: 2, default: 7, null: false
      t.integer :value, default: 0, null: false
      t.integer :previous_value, default: 0, null: false
      t.string :name, null: false
    end

    add_index :metrics, %i[biovision_component_id name]
  end

  def create_metric_values
    create_table :metric_values, comment: 'Component metric values' do |t|
      t.references :metric, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.timestamp :time, null: false
      t.integer :quantity, default: 1, null: false
    end

    execute "create index metric_values_day_idx on metric_values using btree (date_trunc('day', time));"
  end

  def create_languages
    create_table :languages, comment: 'Interface languages' do |t|
      t.integer :priority, limit: 2, default: 1, null: false
      t.boolean :active, default: true, null: false
      t.integer :object_count, default: 0, null: false
      t.string :slug, null: false
      t.string :code, null: false
    end

    Language.create!(code: 'ru', slug: 'russian')
    Language.create!(code: 'en', slug: 'english', active: false)
  end
end
