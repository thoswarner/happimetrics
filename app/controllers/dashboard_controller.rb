class DashboardController < ApplicationController
  def index
  end

  def show
    render :partial => type.to_s
  end

  def type
    @type ||= params[:type]
  end

  def current_day
    @current_day ||= begin
      if params && params['day'] && params['month'] && params['year']
        Date.parse("#{params['day']}/#{params['month']}/#{params['year']}")
      end
    end
  end
  helper_method :current_day

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
