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
  def current_start_of_week_day
    @current_start_of_week_day ||= current_day
  end
  helper_method :current_start_of_week_day

  # A week after current start of week day (excluding the following monday)
  def current_end_of_week_day
    @current_end_of_week_day ||= current_start_of_week_day + 6.days
  end
  helper_method :current_end_of_week_day

  def current_uid
    @current_uid ||= begin
      case type
      when :day
        uid_for_day current_day
      when :week
        uid_for_week current_start_of_week_day
      end
    end
  end
  helper_method :current_uid

  def entries
    @entries ||= begin
      scope = HappinessEntry
      case type
      when :day
        scope.on_date(current_day)
      when :week
        scope.in_week(current_start_of_week_day, current_end_of_week_day)
      end
    end
  end
  helper_method :entries

end
