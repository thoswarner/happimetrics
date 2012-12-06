class MetricValue < ActiveRecord::Base
  attr_accessible :description, :uid, :value, :metric_type, :metric_id, :updated_by_user

  attr_accessor :updated_by_user

  # associations
  belongs_to :metric

  # callbacks
  after_update :update_metric_averages!

  def update_metric_averages!
    MetricCalculation.update_averages_for_metric!(metric) if updated_by_user
  end

  class << self

    def get attrs = {}
      conditions = {:uid => attrs[:uid], :metric_type => attrs[:metric_type], :metric_id => attrs[:metric_id]}
      matches = where(conditions, :limit => 1)
      item = matches.first if matches.any?
      item
    end

    def update attrs = {}
      item = get(attrs)
      if item
        item.update_attributes!(:value => attrs[:value]) unless item.value == attrs[:value]
      else
        create!(
          :uid => attrs[:uid], 
          :metric_type => attrs[:metric_type], 
          :value => attrs[:value], 
          :metric_id => attrs[:metric_id])
      end
    end

  end

end
