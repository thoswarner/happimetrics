class CreateHappinessEntries < ActiveRecord::Migration
  def change
    create_table :happiness_entries do |t|
      t.integer :uid
      t.date :entry_date
      t.time :entry_time
      t.integer :happiness_value
      t.timestamps
    end
  end
end
