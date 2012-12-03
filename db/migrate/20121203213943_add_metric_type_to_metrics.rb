class AddMetricTypeToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :metric_type, :integer
  end
end
