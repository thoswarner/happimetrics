class CreateTableMetricTypesMetrics < ActiveRecord::Migration
  def change
    create_table :metric_types_metrics do |t|
      t.integer  :metric_id
      t.integer  :metric_type_id
    end

    add_index :metric_types_metrics, :metric_type_id
    add_index :metric_types_metrics, :metric_id
  end
end
