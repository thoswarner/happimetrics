class MetricValuesController < InheritedResources::Base
  respond_to :js
  actions :update

  def type
    @type ||= params[:current_type]
  end
  helper_method :type

end
