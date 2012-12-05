module MetricsHelper

  def happiness_distribution uid, type
    MetricCalculation.happiness_distribution(uid, type)
  end

  def average_happiness_distribution type, happiness_value
    metric_type = "average_#{type}_#{happiness_value}_percentage"
    metric_value = MetricValue.find_by_metric_type(metric_type)
    metric_value ? metric_value.value : 0
  end

end
