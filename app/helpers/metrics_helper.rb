module MetricsHelper

  def happiness_distribution uid, type, entries
    MetricCalculation.happiness_distribution(uid, type, entries)
  end

  def average_daily_happiness_distribution happiness_value
    metric_type = "average_day_#{happiness_value}_percentage"
    MetricValue.find_by_metric_type(metric_type).value
  end

end
