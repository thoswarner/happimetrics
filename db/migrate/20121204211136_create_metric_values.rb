class CreateMetricValues < ActiveRecord::Migration
  def change
    create_table :metric_values do |t|
      t.string :uid
      t.text :description
      t.float :value

      t.timestamps
    end
  end
end
