class MetricFormat < ActiveEnum::Base
  value :id => 1, :name => "Currency in pounds", :type => :currency
  value :id => 2, :name => "Days", :type => :days
  value :id => 3, :name => "Hours", :type => :hours
  value :id => 4, :name => "Minutes", :type => :minutes
  value :id => 5, :name => "Number", :type => :number
  value :id => 6, :name => "Percentage", :type => :percentage
end