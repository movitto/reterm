require 'net/http'

# Weather Info Widget
module RETerm
  module Components
    class WeatherInfo < Component
      def initialize(args={})
        @loc    = args[:loc]
        @parent = args[:parent]

        path = "/" +  @loc.gsub("\s*", "+")
        req  = Net::HTTP::Get.new(path,  {'User-Agent' => 'curl'})
        res  = Net::HTTP.new("wttr.in", 80).request(req)
        @results = res.body
      end

      def requested_rows
        [@results.split("\n").size + 1, Terminal.rows-5].min
      end

      def requested_cols
        [@results.split("\n").max { |l1, l2| l1.size <=> l2.size }.size, Terminal.cols-23].min
      end

      def erase
        erase_win
        window.erase
      end

      def draw!
        refresh_win
      end

      private

      def refresh_win
        y = 1
        @results.split("\n").each { |t|
          # TODO convert ansi colors to ncurses colors
          s = parse_ansi(t).collect { |a| a.first }.join
          window.mvaddstr(y, 1, s)
          y += 1
        }
      end

      def erase_win
        y = 1
        @results.split("\n").each { |t|
          s = parse_ansi(t).collect { |a| a.first }.join
          window.mvaddstr(y, 1, " " * s.size)
          y += 1
        }
      end
    end # class WeatherInfo
  end # module Components
end # module RETerm
