module DashboardHelper

  def other_day_path day, direction
    other_day = case direction
    when :previous
      day - 1.day
    when :next
      day + 1.day
    end
    day_path(other_day.day, other_day.month, other_day.year)
  end

  def other_week_path beginning_of_week_day, direction
    other_week = case direction
    when :previous
      beginning_of_week_day - 1.week
    when :next
      beginning_of_week_day + 1.week
    end
    week_path(other_week.day, other_week.month, other_week.year)
  end

  def other_month_path beginning_of_month_day, direction
    other_month = case direction
    when :previous
      beginning_of_month_day - 1.month
    when :next
      beginning_of_month_day + 1.month
    end
    month_path(other_month.month, other_month.year)
  end

  def other_year_path beginning_of_year_day, direction
    other_year = case direction
    when :previous
      beginning_of_year_day - 1.year
    when :next
      beginning_of_year_day + 1.year
    end
    year_path(other_year.year)
  end

  def available_metric_types
    @available_metric_types ||= Metric.all_for_type(type).map(&:metric_types).flatten.uniq.sort_by(&:position)
  end

  def metric_values
    @metric_values ||= Metric.all_for_type(type).inject([]) do |arr, metric|
      metric_type = "#{type}_value"
      arr << metric.metric_values.find_or_create_by_uid_and_metric_type(current_uid, metric_type)
      arr
    end
  end

end
