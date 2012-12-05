class AddIndexesInHappinessEntries < ActiveRecord::Migration
  def change
    add_index :happiness_entries, :uid
    add_index :happiness_entries, :happiness_value
    add_index :happiness_entries, :entry_date
    add_index :happiness_entries, :entry_time
  end
end