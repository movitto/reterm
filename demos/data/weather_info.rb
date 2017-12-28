require 'net/http'

# Weather Info Widget
module RETerm
  module Components
    class WeatherInfo < Component
      def initialize(args={})
        @loc    = args[:loc]
        @parent = args[:parent]

        @results = Net::HTTP.get('wttr.in', @loc.gsub("\s*", "+"))
      end

      def draw!
        refresh_win
      end

      private

      def refresh_win
        window.clear!

        y = 1
        @results.split("\n").each { |t|
          window.mvaddstr(y, 1, t)
          y += 1
        }

        window.refresh
        update_return
      end
    end # class WeatherInfo
  end # module Components
end # module RETerm
