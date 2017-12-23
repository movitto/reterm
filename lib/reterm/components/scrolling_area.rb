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

      def <<(item)
        component.add item, CDK::BOTTOM
      end

      private

      def _component
        CDK::SWINDOW.new(window.cdk_scr,   # cdkscreen,
                         2, 1,             # xplace, yplace, scroll pos
                         window.rows - 2,  # widget height
                         window.cols  - 2, # widget width
                         @title, @lines,   # title, lines
                         true, false)      # box, shadow
      end
    end # ScrollList
  end # module Components
end # module RETerm
