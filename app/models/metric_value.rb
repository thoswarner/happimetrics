class MetricValue < ActiveRecord::Base
  attr_accessible :description, :uid, :value, :metric_type

  # associations
  belongs_to :metric

  class << self

    def get uid, metric_type
      begin
        item = find_by_uid_and_metric_type uid, metric_type
      rescue
        return nil
      end
      item
    end

    def update uid, metric_type, value
      item = get(uid, metric_type)
      if item
        item.update_attributes!(:value => value)
      else
        create!(:uid => uid, :metric_type => metric_type, :value => value)
      end
    end

  end

end
