require "net/http"
require "uri"

class HappinessEntry < ActiveRecord::Base
  default_scope order('entry_date ASC')

  # attributes
  attr_accessible :uid, :entry_date, :entry_time, :happiness_value

  # enumerables
  enumerate :happiness_value

  # scopes
  scope :on_date, lambda {|date| where(:entry_date => date)}
  scope :in_week, lambda {|beginning_of_week_day, end_of_week_day| where("entry_date >= ? AND entry_date <= ?", beginning_of_week_day, end_of_week_day)}
  scope :in_month, lambda {|beginning_of_month_day, end_of_month_day| where("entry_date >= ? AND entry_date <= ?", beginning_of_month_day, end_of_month_day)}
  scope :in_year, lambda {|beginning_of_year_day, end_of_year_day| where("entry_date >= ? AND entry_date <= ?", beginning_of_year_day, end_of_year_day)}

  # merged date
  def entered_at
    @entered_at ||= DateTime.parse("#{entry_date} #{entry_time}")
  end

  # class methods
  class << self

    def dates
      HappinessEntry.select("entry_date").group("entry_date").map(&:entry_date)
    end

    def beginning_of_week_days
      dates.map {|date| date.beginning_of_week }.uniq
    end

    def beginning_of_month_days
      dates.map {|date| date.beginning_of_month }.uniq
    end

    def beginning_of_year_days
      dates.map {|date| date.beginning_of_year }.uniq
    end

    # create relatively random data for every day in the last 3 months
    def fauxify!
      # cleanup the old ones
      self.delete_all
      # instantiate beginning date
      date = 13.months.ago.to_date
      # loop through the days till today
      cutoff_date = Date.parse("23/11/2012")
      until date == cutoff_date
        # skip weekends
        unless (date.saturday? || date.sunday?)
          # choose a random number of entries between 3 and 25
          number_of_entries = (3..25).to_a.sample
          # create the given number of entries
          number_of_entries.times do
            hour = (9..17).to_a.sample
            minute = (0..59).to_a.sample
            # choose a random time in the day between 09:00 and 17:30 and a random happiness value
            entered_at = DateTime.parse("#{date} #{hour}:#{minute}")
            # happiness_value = HappinessValue[]
            entry_date = entered_at.to_date
            entry_time = entered_at.to_time
            uid = entered_at.to_i
            happiness_entry = self.create(:uid => uid, :entry_date => entry_date, :entry_time => entry_time, :happiness_value => [1,1,1,2,3].sample) unless happiness_entry
          end
        end
        date = date + 1.day
      end
    end

    def update!
      logger.info "Accessing entries data..."
      uri = URI.parse("http://spreadsheets.google.com/feeds/list/0AnXMCsqfd3RQdHJkVTc4cjduTE95Q0lFYTA5b3ZTUmc/od6/public/values?alt=json")
      response = Net::HTTP.get_response(uri)
      if response.code == "200"
        logger.info "Entries data received."
        data = JSON.parse(response.body)
        last_entry = self.last
        logger.info "Parsing entries data..."
        entries = data["feed"]["entry"].inject([]) do |arr, entry|
          entry_date = Date.strptime(entry["gsx$date"]["$t"], "%m/%d/%Y")
          entry_time = DateTime.parse("#{entry_date} #{entry["gsx$time"]["$t"]}")
          happiness_value = HappinessValue[entry["gsx$status"]["$t"].downcase]
          valid_entry = true
          if last_entry
            valid_entry = (entry_date > last_entry.entry_date && entry_time > last_entry.entry_time)
          end
          if valid_entry
            arr << {:entry_date => entry_date, :entry_time => entry_time, :happiness_value => happiness_value}
          end
          arr
        end
        logger.info "Number of new entries found: #{entries.size}"
        if entries.any?
          logger.info "Adding new entries"
          entries.each do |entry|
            uid = entry[:entry_time].to_i
            self.create!(:uid => uid, :entry_date => entry[:entry_date], :entry_time => entry[:entry_time], :happiness_value => entry[:happiness_value])
          end
          logger.info "Entries update complete!"
        else
          logger.info "Nothing to do here..."
        end
      else
        logger.info "There was a problem accessing the entries data. Ending update process..."
      end
    end

  end

end