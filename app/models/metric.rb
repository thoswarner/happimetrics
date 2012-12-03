class Metric < ActiveRecord::Base
  attr_accessible :description, :title, :metric_type

  # enumerables
  enumerate :metric_type

  #validations
  validates :title, :description, :metric_type, :presence => true

end
