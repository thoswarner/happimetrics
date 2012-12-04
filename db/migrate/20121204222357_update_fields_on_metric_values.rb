class UpdateFieldsOnMetricValues < ActiveRecord::Migration
  def change
    add_column :metric_values, :metric_type, :string
  end
end
