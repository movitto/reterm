module RETerm
  module Components
    # Scrolling Area CDK Component
    class ScrollingArea < Component
      include CDKComponent

      # Initialize the ScrollingArea component
      #
      # @param [Hash] args scrolling area params
      # @option args [String] :title title of area
      # @option args [Integer] :lines number of lines
      #   in the area
      def initialize(args={})
        @title  = args[:title] || ""
        @lines  = args[:lines] || 10
      end

      # XXX swindow results in weird keyboard interactions, disable for now
      def activatable?
        false
      end

      def requested_rows
        10
      end

      def requested_cols
        [@title.size, 10].min
      end

      def <<(item)
        component.add item, CDK::BOTTOM
      end

      private

      def _component
        CDK::SWINDOW.new(window.cdk_scr, # cdkscreen,
                         0, 1,           # xplace, yplace, scroll pos
                         window.rows,    # widget height
                         window.cols,    # widget width
                         @title, @lines, # title, lines
                         true, false)    # box, shadow
      end
    end # ScrollList
  end # module Components
end # module RETerm
