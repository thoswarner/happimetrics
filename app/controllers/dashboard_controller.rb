class DashboardController < ApplicationController
  def index
  end

  def type
    @type ||= params[:type]
  end
  helper_method :type

  def current_day
    @current_day ||= begin
      if params && params['day'] && params['month'] && params['year']
        Date.parse("#{params['day']}/#{params['month']}/#{params['year']}")
      end
    end
  end
  helper_method :current_day

  def current_uid
    @current_uid ||= begin
      case type
      when :day
        uid_for_day(current_day)
      end
    end
  end
  helper_method :current_uid

  def entries
    @entries ||= begin
      case type
      when :day
        HappinessEntry.on_date(current_day)
      end
    end
  end
  helper_method :entries

end
