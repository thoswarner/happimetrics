class AddUidToMetricTypes < ActiveRecord::Migration
  def change
    add_column :metric_types, :uid, :string
  end
end
