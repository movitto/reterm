module RETerm
  module Components
    # Alpha List CDK Component
    class AlphaList < Component
      include CDKComponent
      include ItemHelpers

      # Initialize the AlphaList component
      #
      # @param [Hash] args list params
      # @option args [String] :title title of list
      # @option args [String] :label title of list
      # @option args [Array<String>] :items items to
      #   populate list with
      def initialize(args={})
        @title  = args[:title] || ""
        @label  = args[:label] || ""
        @items  = args[:items] || []
      end

      def requested_rows
        [@items.size + 5, 10].min
      end

      def requested_cols
        [@title.size, @label.size, max_item_size, 20].max + 2
      end

      private

      def _component
        CDK::ALPHALIST.new(window.cdk_scr,
                           2, 1,               # x, y
                           window.rows - 2,    # height
                           window.cols - 2,    # width
                           @title, @label,
                           @items, @items.size,
                           '_',                # filler char
                           Ncurses::A_REVERSE, # highlight
                           true, false)        # box, shadow
      end
    end # AlphaList
  end # module Components
end # module RETerm
