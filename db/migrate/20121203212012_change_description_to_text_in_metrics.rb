class ChangeDescriptionToTextInMetrics < ActiveRecord::Migration
  def up
  	change_column(:metrics, :description, :text)
  end

end
