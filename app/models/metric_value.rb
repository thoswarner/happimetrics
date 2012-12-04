class MetricValue < ActiveRecord::Base
  attr_accessible :description, :uid, :value

  class << self

    def get uid
      begin
        item = find_by_uid uid
      rescue
        return nil
      end
      item
    end

    def update uid, value
      item = get(uid)
      if item
        item.update_attributes!(:value => value)
      else
        create!(:uid => uid, :value => value)
      end
    end

  end

end
