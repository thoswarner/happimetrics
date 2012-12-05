class MetricsController < InheritedResources::Base
  actions :all, :except => [:show]
end
