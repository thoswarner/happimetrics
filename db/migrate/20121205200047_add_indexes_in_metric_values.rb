class AddIndexesInMetricValues < ActiveRecord::Migration
  def change
    add_index :metric_values, :uid
    add_index :metric_values, :value
    add_index :metric_values, :metric_type
  end
end
