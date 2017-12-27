module RETerm
  module Components
    # CDK Histogram Widget
    class Histogram < Component
      include CDKComponent

      attr_accessor :value

      # Override setter
      def value=(v)
        component.set(:PERCENT,        # view type
                      CDK::CENTER,     # stats pos
                      Ncurses::A_BOLD, # stats attr
                      @min, @max, v,   # low/high/current
                      ' '.ord | Ncurses::A_REVERSE, # fill ch
                      true)            # box

        window.cdk_scr.refresh
      end

      # Initialize the Histogram component
      #
      # @param [Hash] args label params
      # @option args [String] :title title of Histogram
      # @option args [Integer] :min min histogram value
      # @option args [Integer] :max max histogram value
      def initialize(args={})
        @title = args[:title] || ""
        @min   = args[:min]   || 0
        @max   = args[:max]   || 10
      end

      def requested_rows
        4
      end

      def requested_cols
        50
      end

      private

      def _component
        CDK::HISTOGRAM.new(window.cdk_scr,
                           2, 1,            # x, y
                           1, -2,           # h, w
                           CDK::HORIZONTAL, # orient
                           @title,
                           true, false)     # box, shadow
      end

    end # Histogram
  end # module Components
end # module RETerm
