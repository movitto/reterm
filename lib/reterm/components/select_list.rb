module RETerm
  module Components
    # Select List CDK Component
    class SelectList < Component
      include CDKComponent
      include ItemHelpers

      # Initialize the SelectList component
      #
      # @param [Hash] args list params
      # @option args [String] :title title of list
      # @option args [Array<String>] :items items to
      #   populate list with
      def initialize(args={})
        @title  = args[:title] || ""
        @items  = args[:items] || []
      end

      def requested_rows
        3 + @items.size
      end

      def requested_cols
        [@title.size, max_item_size + 4].min
      end

      def selected
        (0...@items.size).collect { |i|
          component.selections[i] == 1 ? @items[i] : nil
        }.compact
      end

      def activate!(*input)
        super
        selected
      end

      private

      def _component
        choices = [
            "   ",
            "-->"
        ]

        CDK::SELECTION.new(window.cdk_scr,                          # cdkscreen,
                           2, 1, CDK::RIGHT,                       # xplace, yplace, select pos
                           window.rows - 2,                        # widget height
                           window.cols  - 2,                       # widget width
                           @title,                                 # title
                           @items, @items.size,                    # items
                           choices, choices.size,                  # space bar choices
                           Ncurses::A_REVERSE,                     # highlight
                           true, false)                            # box, shadow
      end
    end # ScrollList
  end # module Components
end # module RETerm
