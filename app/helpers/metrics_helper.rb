module MetricsHelper

  def happiness_distribution uid, entries
    MetricCalculation.happiness_distribution(uid, entries)
  end

end
