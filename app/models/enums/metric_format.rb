class MetricFormat < ActiveEnum::Base
  value :id => 1, :name => "Currency in pounds", :type => :currency, :before => "&pound;", :after => nil
  value :id => 2, :name => "Days", :type => :days, :before => nil, :after => "days"
  value :id => 3, :name => "Hours", :type => :hours, :before => nil, :after => "hours"
  value :id => 4, :name => "Minutes", :type => :minutes, :before => nil, :after => "minutes"
  value :id => 5, :name => "Number", :type => :number, :before => nil, :after => nil
  value :id => 6, :name => "Percentage", :type => :percentage, :before => nil, :after => "%"
end