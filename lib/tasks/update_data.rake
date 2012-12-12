namespace :data do 
  desc "Update data from happiness feed and update metric averages"
  task :update => :environment do
    Rails.logger = Logger.new(STDOUT)
    puts "Beginning update..."
    HappinessEntry.update!
    MetricCalculation.update_metric_values!
    puts "Finished update."
  end
end