module RETerm
  module Components
    # Scrolling List CDK Component
    class ScrollList < Component
      include CDKComponent

      # Initialize the ScrollList component
      #
      # @param [Hash] args list params
      # @option args [String] :title title of list
      # @option args [Array<String>] :items items to
      #   populate list with
      def initialize(args={})
        @title  = args[:title] || ""
        @items  = args[:items] || []
      end

      private

      def _component
        CDK::SCROLL.new(window.cdk_scr,                          # cdkscreen,
                        2, 1, CDK::RIGHT,                       # xplace, yplace, scroll pos
                        window.rows - 2,                        # widget height
                        window.cols  - 2,                       # widget width
                        @title, @items, @items.size,            # title and items
                        false,                                  # prefix numbers
                        Ncurses::A_REVERSE,                     # highlight
                        true, false)                            # box, shadow
      end
    end # ScrollList
  end # module Components
end # module RETerm
