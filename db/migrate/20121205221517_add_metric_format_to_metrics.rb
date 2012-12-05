class AddMetricFormatToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :metric_format, :integer
  end
end
