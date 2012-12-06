class AddPositionToMetricTypes < ActiveRecord::Migration
  def change
    add_column :metric_types, :position, :integer
  end
end
