class HappinessEntry

  # attributes
  attr_accessor :entered_at, :value

  # make this class look like a model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveEnum::Extensions
  extend ActiveModel::Naming

  # enumerables
  enumerate :happiness_value

  def self.attr_accessor(*vars)
    @attributes ||= []
    @attributes.concat( vars )
    super
  end

 def self.attributes
   @attributes
 end

 def initialize(attributes={})
   attributes && attributes.each do |name, value|
     send("#{name}=", value) if respond_to? name.to_sym 
   end
 end

  def persisted?
    false
  end

  def self.inspect
    "#<#{ self.to_s} #{ self.attributes.collect{ |e| ":#{ e }" }.join(', ') }>"
  end

  # create relatively random data for every day in the last 3 months
  def self.fauxify!
    # instantiate beginning date
    date = 3.months.ago.to_date
    # object to stash entries
    happiness_entries = []
    # loop through the days till today
    until date == Date.today
      # skip weekends
      unless (date.saturday? || date.sunday?)
        # choose a random number of entries between 3 and 25
        number_of_entries = (3..25).to_a.sample
        # array to stash the current dates entries
        happiness_entries_for_date = []
        # create the given number of entries
        number_of_entries.times do
          hour = (9..17).to_a.sample
          minute = (0..59).to_a.sample
          # choose a random time in the day between 09:00 and 17:30 and a random happiness value
          entered_at = DateTime.parse("#{date} #{hour}:#{minute}")
          value = HappinessValue[[1,2,3].sample]
          happiness_entries_for_date << self.new(:entered_at => entered_at, :value => value)
        end
        Rails.cache.write date, happiness_entries_for_date, :expires_in => 60.minutes
      end
      date = date + 1.day
    end
  end

  def self.all attributes = {}
    date = attributes[:date].to_s 
    entries = []
    if Rails.cache.exist? date
      entries = Rails.cache.fetch(date)
      entries.sort! { |a,b| a.entered_at <=> b.entered_at }
    end
    entries
  end

end