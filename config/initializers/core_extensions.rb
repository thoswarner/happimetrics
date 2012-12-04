module Happimetrics
  module CoreExtensions
    module Object
      def uid_for_date date
        date.to_datetime.to_i
      end
    end
  end
end

Object.send :include, Happimetrics::CoreExtensions::Object