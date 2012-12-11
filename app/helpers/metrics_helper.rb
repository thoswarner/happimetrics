module MetricsHelper

  def happiness_distribution uid, type
    MetricCalculation.happiness_distribution(uid, type)
  end

  def average_happiness_distribution type, happiness_value
    metric_type = "average_#{type}_#{happiness_value}_percentage"
    metric_value = MetricValue.find_by_metric_type(metric_type)
    metric_value ? metric_value.value : 0
  end

  def average_metric_value type, metric, formatted = true
    metric_type = "average_#{type}"
    metric_value = MetricValue.get(:metric_type => metric_type, :metric_id => metric.id)
    if metric_value && metric_value.value != 0.0
      value = formatted ? formatted_metric_value(metric_value) : metric_value.value
    else
      value = "--"
    end
  end

    # format the value output depending on the metric format
  def formatted_metric_value metric_value
    return "MISSING" unless metric_value.value
    case metric_value.metric.metric_format(:type)
    when :currency
      number_to_currency(metric_value.value, :unit => metric_value.metric.metric_format(:before))
    when :days, :hours, :minutes, :percentage
      "#{metric_value.value.round(2)} #{metric_value.metric.metric_format(:after)}"
    else
      metric_value.value.round(2)
    end
  end

  def metric_status current_value, average_metric
    classes = ["metric-status"]
    if current_value
      if current_value > average_metric
        content = "Above average"
        classes << "above-average"
      else
        content = "Below average"
        classes << "below-average"
      end
    end
    content_div = content_tag(:div, content, :class => classes)
  end


end

