class MetricCalculation

  class << self

    # format happiness distribution for a given uid (day, week, month) as a hash
    def happiness_distribution uid, type
      HappinessValue.names.inject({}) do |hash, happiness_value|
        metric_type = "#{type}_#{happiness_value}_percentage"
        metric_value = MetricValue.get(:uid => uid, :metric_type => metric_type)
        hash[happiness_value] = metric_value.value if metric_value
        hash
      end
    end

    def update_averages_for_metric! metric
      metric.metric_types.each do |metric_type|
        value_metric_type = "#{metric_type.uid}_value"
        average_metric_type = "average_#{metric_type.uid}"
        average_for_value = MetricValue.where(:metric_id => metric.id, :metric_type => value_metric_type).average(:value).to_f
        MetricValue.update(:metric_type => average_metric_type, :value => average_for_value, :metric_id => metric.id)
      end
    end


    # Metric updating

    # calculate metric values in bulk (background task)
    def update_metric_values!
      update_daily_happiness_distributions!
      update_weekly_happiness_distributions!
      update_monthly_happiness_distributions!
      update_annual_happiness_distributions!
      update_average_happiness_distributions!
      update_averages_for_metrics!
    end

    # update average values for all the metrics
    def update_averages_for_metrics!
      Metric.all.each do |metric|
        update_averages_for_metric!(metric)
      end
    end

    # update average happiness distribution for each type (day, week, month, yeah)
    def update_average_happiness_distributions!
      [:day, :week, :month, :year].each do |type|      
        HappinessValue.names.each do |happiness_value|
          metric_type = "#{type}_#{happiness_value}_percentage"
          average_metric_type = "average_#{metric_type}"
          average_for_value = MetricValue.where(:metric_type => metric_type).average(:value).to_f
          MetricValue.update(:metric_type => average_metric_type, :value => average_for_value)
        end
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
      HappinessEntry.beginning_of_week_days.each do |beginning_of_week_day|
        uid = uid_for_week(beginning_of_week_day)
        end_of_week_day = beginning_of_week_day.end_of_week
        entries_for_week = HappinessEntry.in_week(beginning_of_week_day, end_of_week_day)
        update_happiness_distribution! uid, :week, entries_for_week       
      end
    end

    # update happiness distribution for every week 
    def update_monthly_happiness_distributions!      
      HappinessEntry.beginning_of_month_days.each do |beginning_of_month_day|
        uid = uid_for_month(beginning_of_month_day)
        end_of_month_day = beginning_of_month_day.end_of_month
        entries_for_month = HappinessEntry.in_month(beginning_of_month_day, end_of_month_day)
        update_happiness_distribution! uid, :month, entries_for_month       
      end
    end

    # update happiness distribution for every year 
    def update_annual_happiness_distributions!      
      HappinessEntry.beginning_of_year_days.each do |beginning_of_year_day|
        uid = uid_for_year(beginning_of_year_day)
        end_of_year_day = beginning_of_year_day.end_of_year
        entries_for_year = HappinessEntry.in_year(beginning_of_year_day, end_of_year_day)
        update_happiness_distribution! uid, :year, entries_for_year       
      end
    end

    # calculate happiness distribution for a given uid (day, week, month, yeah) and stash it
    def update_happiness_distribution! uid, type, entries
      HappinessValue.names.inject({}) do |hash, happiness_value|
        metric_type = "#{type}_#{happiness_value}_percentage"
        matching_entries = entries.select {|entry| entry.happiness_value == happiness_value }
        percentage = (matching_entries.count / entries.length.to_f) * 100
        MetricValue.update(:uid => uid, :metric_type => metric_type, :value => percentage)
      end
    end

  end

end