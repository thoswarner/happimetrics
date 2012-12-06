class MetricType < ActiveRecord::Base
  attr_accessible :title

  default_scope order('position ASC')

end
