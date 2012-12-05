module Happimetrics
  module CoreExtensions
    module Object

      def uid_for_day date
        date.strftime("day-%d-%m-%Y")
      end

      def uid_for_week date
        date.strftime("week-%d-%m-%Y")
      end

      def uid_for_month date
        date.strftime("month-%m-%Y")
      end

      def uid_for_year date
        date.strftime("year-%Y")
      end

    end
  end
end

Object.send :include, Happimetrics::CoreExtensions::Object