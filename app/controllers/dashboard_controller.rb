class DashboardController < ApplicationController
  def index
  end

  def type
    @type ||= params[:type]
  end
  helper_method :type

  # current day, if the type is day
  def current_day
    @current_day ||= begin
      if params && params['day'] && params['month'] && params['year']
        Date.parse("#{params['day']}/#{params['month']}/#{params['year']}")
      end
    end
  end
  helper_method :current_day

  # same as current day, but represents the beginning of a given week
  def current_beginning_of_week_day
    @current_beginning_of_week_day ||= current_day
  end
  helper_method :current_beginning_of_week_day

  # grab the first day of the month from the params
  def current_beginning_of_month_day
    @current_beginning_of_month_day ||= begin
      if params && params['month'] && params['year']
        Date.parse("01/#{params['month']}/#{params['year']}")
      end
    end
  end
  helper_method :current_beginning_of_month_day

  # grab the first day of the year from the params
  def current_beginning_of_year_day
    @current_beginning_of_year_day ||= begin
      if params && params['year']
        Date.parse("01/01/#{params['year']}")
      end
    end
  end
  helper_method :current_beginning_of_year_day

  def current_uid
    @current_uid ||= begin
      case type
      when :day
        uid_for_day current_day
      when :week
        uid_for_week current_beginning_of_week_day
      when :month
        uid_for_month current_beginning_of_month_day
      when :year
        uid_for_year current_beginning_of_year_day
      end
    end
  end
  helper_method :current_uid

  def entries
    @entries ||= begin
      scope = HappinessEntry
      case type
      when :day
        scope.on_date(current_day).order("entry_time asc")
      when :week
        scope.in_week(current_beginning_of_week_day, current_beginning_of_week_day.end_of_week)
      when :month
        scope.in_month(current_beginning_of_month_day, current_beginning_of_month_day.end_of_month)
      when :year
        scope.in_month(current_beginning_of_year_day, current_beginning_of_year_day.end_of_year)
      end
    end
  end
  helper_method :entries

end
