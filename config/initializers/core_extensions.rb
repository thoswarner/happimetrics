module Happimetrics
  module CoreExtensions
    module Object

      def uid_for_day date
        date.strftime("%d-%m-%Y")
      end

      def uid_for_month date
        date.strftime("%m-%Y")
      end

      def uid_for_year date
        date.strftime("%m-%Y")
      end

    end
  end
end

Object.send :include, Happimetrics::CoreExtensions::Object