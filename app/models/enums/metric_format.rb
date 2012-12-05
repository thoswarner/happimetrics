class MetricFormat < ActiveEnum::Base
  value :id => 1, :name => "Currency in pounds", :type => :currency
  value :id => 2, :name => "Hours", :type => :hours
  value :id => 3, :name => "Minutes", :type => :minutes
  value :id => 4, :name => "Number", :type => :number
  value :id => 5, :name => "Percentage", :type => :percentage
end