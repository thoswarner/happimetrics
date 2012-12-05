class Metric < ActiveRecord::Base
  attr_accessible :description, :title, :metric_type_ids, :metric_format

  # enumerables
  enumerate :metric_format

  # associations
  has_and_belongs_to_many :metric_types

  #validations
  validates :title, :description, :metric_format, :metric_types, :presence => true

end
