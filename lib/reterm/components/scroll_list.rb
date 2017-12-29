module RETerm
  module Components
    # Scrolling List CDK Component
    class ScrollList < Component
      include CDKComponent
      include ItemHelpers

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

      def requested_rows
        @items.size + 1
      end

      def requested_cols
        [@title.size, max_item_size].min
      end

      def <<(item)
        @items << item
      end

      def selected
        @items[component.getCurrentItem]
      end

      def activate!
        i = super
        return nil unless normal_exit?
        @items[i]
      end

      private

      def _component
        c = CDK::SCROLL.new(window.cdk_scr,                          # cdkscreen,
                        2, 1, CDK::RIGHT,                       # xplace, yplace, scroll pos
                        window.rows - 2,                        # widget height
                        window.cols  - 2,                       # widget width
                        @title, @items, @items.size,            # title and items
                        false,                                  # prefix numbers
                        Ncurses::A_REVERSE,                     # highlight
                        true, false)                            # box, shadow

        pp = lambda do |cdktype, list, scroll_list, key|
          scroll_list.dispatch("selected")
        end

        c.setPostProcess(pp, self)

        c
      end
    end # ScrollList
  end # module Components
end # module RETerm
