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

  def span date
    if date.saturday? || date.sunday?
      "span1"
    else
      "span2"
    end
  end

  def offset date
    ""
  end

  def all_happiness_distributions
    @all_happiness_distributions ||= all_days.inject({}) do |hash, date|
      happiness_distributions = MetricCalculation.happiness_distribution(uid_for_day(date), :day)
      HappinessValue.names.each do |happiness_value|
        current_value = happiness_distributions[happiness_value].round(2)
        hash[happiness_value] ? hash[happiness_value] << current_value : hash[happiness_value] = [current_value]
      end
      hash
    end
  end

  def all_days
    (current_beginning_of_month_day..current_beginning_of_month_day.end_of_month).to_a.select do |date| 
      !date.saturday? && !date.sunday?
    end
  end

  def entries_graph
    @h = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart] = {:defaultSeriesType => "area", :backgroundColor => "#f7f6f4"}
      f.options[:title] = {:text => "Happiness distribution", :style => {:fontSize => "30px", :fontFamily => "'Unica One', cursive"}}
      f.options[:plotOptions][:area] = {
          stacking: 'percent',
          lineColor: '#ffffff',
          lineWidth: 1,
          marker: {
              lineWidth: 1,
              lineColor: '#ffffff'
          }
      }
      f.options[:colors] = ['#89A54E', '#4572A7', '#AA4643']
      f.options[:legend] = {:borderWidth => 0}
      f.xAxis!(:categories => all_days.map {|date| date.strftime("%a #{date.day.ordinalize}") }, :tickmarkPlacement => "on", :title => {:enabled => false})
      f.yAxis(:title => { text: 'Percent' } )
      HappinessValue.names.each do |happiness_value|
        f.series(:name => happiness_value.titleize, :data => all_happiness_distributions[happiness_value])
      end
    end
    high_chart("entries_graph", @h) do |c|
      "options.tooltip.formatter = function() { return '' + this.x +': '+ Highcharts.numberFormat(this.percentage, 1) +'%'; }".html_safe
    end
  end

end
