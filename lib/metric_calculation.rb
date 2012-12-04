class MetricCalculation

  class << self

    # format happiness distribution for a given uid (day, week, month) as a hash
    def happiness_distribution uid, entries
      HappinessValue.all.inject({}) do |hash, happiness_value|
        name = happiness_value[1]
        current_uid = "#{uid}_#{name}_percentage"
        metric_value = MetricValue.get(current_uid)
        hash[name] = metric_value.value if metric_value
        hash
      end
    end

    # Metric updating

    # calculate happiness distribution for a given uid (day, week, month) and stash it
    def update_happiness_distribution! uid, entries
      HappinessValue.all.inject({}) do |hash, happiness_value|
        name = happiness_value[1]
        current_uid = "#{uid}_#{name}_percentage"
        matching_entries = entries.select {|entry| entry.happiness_value == name }
        percentage = (matching_entries.count / entries.length.to_f) * 100
        MetricValue.update(current_uid, percentage)
      end
    end

    # calculate metric values in bulk (background task)
    def update_metric_values
      update_all_happiness_distributions!
      update_average_happiness_distributions!
    end

    # update happiness distribution for every day 
    def update_average_happiness_distributions!      
      HappinessEntry.dates.each do |date|
        uid = uid_for_date(date)
        entries_for_date = HappinessEntry.on_date(date)
        update_happiness_distribution! uid, entries_for_date       
      end
    end

  end

end