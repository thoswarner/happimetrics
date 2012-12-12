module DashboardHelper

  # adjectivise type
  def type_adjective type
    case type
    when :day
      "daily"
    when :week
      "weekly"
    when :month
      "monthly"
    when :year
      "annual"
    end
  end

  #path for a given day
  def other_day_path day, direction
    other_day = case direction
    when :previous
      day - 1.day
    when :next
      day + 1.day
    end
    day_path(other_day.day, other_day.month, other_day.year)
  end

  # path for a given week
  def other_week_path beginning_of_week_day, direction
    other_week = case direction
    when :previous
      beginning_of_week_day - 1.week
    when :next
      beginning_of_week_day + 1.week
    end
    week_path(other_week.day, other_week.month, other_week.year)
  end

  # path for a given month
  def other_month_path beginning_of_month_day, direction
    other_month = case direction
    when :previous
      beginning_of_month_day - 1.month
    when :next
      beginning_of_month_day + 1.month
    end
    month_path(other_month.month, other_month.year)
  end

  # path for a given year
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

  # describe a week with options links
  def week_description date, links = false
    if links
      start_of_week = date.strftime("%d")
      start_of_week += " #{link_to(date.strftime("%B"), month_path(date.month), :class => "")}"
      start_of_week += " #{link_to(date.year, year_path(date.year), :class => "")}"
      end_of_week = date.end_of_week.strftime("%d")
      end_of_week += " #{link_to(date.end_of_week.strftime("%B"), month_path(date.end_of_week.month), :class => "")}"
      end_of_week += " #{link_to(date.end_of_week.year, year_path(date.end_of_week.year), :class => "")}"
    else
      start_of_week = date.strftime("#{date.day.ordinalize}")
      end_of_week = date.end_of_week.strftime("#{date.end_of_week.day.ordinalize}")
    end
    "#{start_of_week} to #{end_of_week}".html_safe
  end

  # Graphing bits

  # get the distributions values in a hash, dependant on type
  def all_happiness_distributions_for_chart type
    @all_happiness_distributions_for_chart ||= categories(type).inject({}) do |hash, date|
      uid = type == :year ? uid_for_month(date) : uid_for_day(date)
      distribution_type = type == :year ? :month : :day
      happiness_distributions = MetricCalculation.happiness_distribution(uid, distribution_type)
      HappinessValue.names.each do |happiness_value|
        current_value = happiness_distributions[happiness_value] ? happiness_distributions[happiness_value].round(2) : 0.0
        item = {:y => current_value}
        item[:url] = type == :year ? month_path(date.month, date.year) : day_path(date.day, date.month, date.year)
        hash[happiness_value] ? hash[happiness_value] << item : hash[happiness_value] = [item]
      end
      hash
    end
  end

  # items for the y axis
  def categories type
    @categories ||= case type
      when :week
        (current_beginning_of_week_day..current_beginning_of_week_day.end_of_week).to_a.select do |date| 
          !date.saturday? && !date.sunday?
        end
      when :month
        (current_beginning_of_month_day..current_beginning_of_month_day.end_of_month).to_a.select do |date| 
          !date.saturday? && !date.sunday?
        end
      when :year
        (current_beginning_of_year_day..current_beginning_of_year_day.end_of_year).to_a.select do |date| 
          date.day == 1
        end
    end
  end

  # names of the items for the y-axis
  def category_names(type)
    @category_names ||= case type
    when :week, :month
      categories(type).map {|date| date.strftime("%a #{date.day.ordinalize}") }
    when :year
      categories(type).map {|date| date.strftime("%B %Y") }
    end
  end

  # highchart
  def entries_graph type
    @graph = LazyHighCharts::HighChart.new('graph') do |f|
      f.options[:chart] = {:defaultSeriesType => "area", :backgroundColor => "#f7f6f4"}
      f.options[:title] = {:text => "Happiness distribution for #{type}", :style => {:fontSize => "30px", :fontFamily => "'Unica One', cursive"}}
      f.options[:subtitle] = {:text => "Click on a data point to drill down to further metric data", :y => 50, :style => {:fontSize => "14px", :fontWeight => "bold" }}
      f.options[:plotOptions][:area] = {
          stacking: 'percent',
          lineColor: '#ffffff',
          lineWidth: 1,
          marker: { lineWidth: 1, lineColor: '#ffffff'},
      }
      f.options[:plotOptions][:series] = {:cursor => "pointer", :point => { events: { click: "function() { window.open(this.options.url) }"} } }
      f.options[:colors] = ['#89A54E', '#4572A7', '#AA4643']
      f.options[:legend] = {:borderWidth => 0}
      f.xAxis!(:categories => category_names(type), :tickmarkPlacement => "on", 
        :title => {:enabled => false}, :labels => {:rotation => 90, :y => 40} )
      f.yAxis(:title => { text: 'Percent' })
      HappinessValue.names.each do |happiness_value|
        f.series(:name => happiness_value.titleize, :data => all_happiness_distributions_for_chart(type)[happiness_value])
      end
    end
  end

end
