class MetricType < ActiveRecord::Base
  attr_accessible :title, :uid, :position

  default_scope order('position ASC')

end
