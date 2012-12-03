class MetricType < ActiveEnum::Base
  value :id => 1, :name => :daily
  value :id => 2, :name => :monthly
  value :id => 3, :name => :annually
end