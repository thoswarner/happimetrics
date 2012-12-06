class AddMetricIdToMetricValues < ActiveRecord::Migration
  def change
    add_column :metric_values, :metric_id, :integer
  end
end
