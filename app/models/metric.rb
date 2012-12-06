class Metric < ActiveRecord::Base
  attr_accessible :description, :title, :metric_type_ids, :metric_format

  # enumerables
  enumerate :metric_format

  # associations
  has_and_belongs_to_many :metric_types
  has_many :metric_values

  #validations
  validates :title, :description, :metric_format, :metric_types, :presence => true

  # class methods

  class << self

    # find the metrics that are available for the given type (day, week, month, year)
    def all_for_type type
      metric_type = MetricType.find_by_uid(type)
      all.select {|metric| metric.metric_types.include? metric_type }
    end

  end

end
