class MetricCalculation

  class << self

    # format happiness distribution for a given uid (day, week, month) as a hash
    def happiness_distribution uid, type
      HappinessValue.names.inject({}) do |hash, happiness_value|
        metric_type = "#{type}_#{happiness_value}_percentage"
        metric_value = MetricValue.get(uid, metric_type)
        hash[happiness_value] = metric_value.value if metric_value
        hash
      end
    end

    # Metric updating

    # calculate metric values in bulk (background task)
    def update_metric_values!
      update_daily_happiness_distributions!
      update_weekly_happiness_distributions!
      update_average_daily_happiness_distributions!
      update_average_weekly_happiness_distributions!
    end

    # update average happiness distribution for every day 
    def update_average_daily_happiness_distributions!      
      HappinessValue.names.each do |happiness_value|
        metric_type = "day_#{happiness_value}_percentage"
        average_metric_type = "average_#{metric_type}"
        average_for_value = MetricValue.where(:metric_type => metric_type).average(:value).to_f
        MetricValue.update(nil, average_metric_type, average_for_value)
      end
    end

    # update average happiness distribution for every week 
    def update_average_weekly_happiness_distributions!      
      HappinessValue.names.each do |happiness_value|
        metric_type = "week_#{happiness_value}_percentage"
        average_metric_type = "average_#{metric_type}"
        average_for_value = MetricValue.where(:metric_type => metric_type).average(:value).to_f
        MetricValue.update(nil, average_metric_type, average_for_value)
      end
    end

    # update happiness distribution for every day 
    def update_daily_happiness_distributions!      
      HappinessEntry.dates.each do |date|
        uid = uid_for_day(date)
        entries_for_date = HappinessEntry.on_date(date)
        update_happiness_distribution! uid, :day, entries_for_date       
      end
    end

    # update happiness distribution for every week 
    def update_weekly_happiness_distributions!      
      HappinessEntry.start_of_week_days.each do |start_of_week_day|
        uid = uid_for_week(start_of_week_day)
        end_of_week_day = start_of_week_day + 6.days
        entries_for_week = HappinessEntry.in_week(start_of_week_day, end_of_week_day)
        update_happiness_distribution! uid, :week, entries_for_week       
      end
    end

    # calculate happiness distribution for a given uid (day, week, month) and stash it
    def update_happiness_distribution! uid, type, entries
      HappinessValue.names.inject({}) do |hash, happiness_value|
        metric_type = "#{type}_#{happiness_value}_percentage"
        matching_entries = entries.select {|entry| entry.happiness_value == happiness_value }
        percentage = (matching_entries.count / entries.length.to_f) * 100
        MetricValue.update(uid, metric_type, percentage)
      end
    end

  end

end