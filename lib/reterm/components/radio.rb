module RETerm
  module Components
    # CDK Radio Component
    class Radio < Component
      include CDKComponent
      include ItemHelpers

      # Initialize the Radio component
      #
      # @param [Hash] args radio params
      # @option args [String] :title title of radio
      # @option args [Array<String>] :items items to
      #   populate radio with
      def initialize(args={})
        super
        @title  = args[:title] || ""
        @items  = args[:items] || []
      end

      def requested_rows
        @items.size
      end

      def requested_cols
        max_item_size + 3
      end

      private

      def _component
        CDK::RADIO.new(window.cdk_scr,                         # cdkscreen,
                       2, 1, CDK::RIGHT,                       # xplace, yplace, scroll pos
                       window.rows - 2,                        # widget height
                       window.cols  - 2,                       # widget width
                       @title, @items, @items.size,            # title and items
                       '#'.ord | Ncurses::A_REVERSE,           # choice char
                       true,                                   # default item
                       Ncurses::A_REVERSE,                     # highlight
                       true, false)                            # box, shadow
      end
    end # Radio
  end # module Components
end # module RETerm
