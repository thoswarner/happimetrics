class MetricValuesController < InheritedResources::Base
  respond_to :js
  actions :update

  def type
    @type ||= params[:current_type].to_sym
  end
  helper_method :type

end
