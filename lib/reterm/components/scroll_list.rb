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
        [@title.size, max_item_size].max + 2
      end

      def <<(item)
        @items << item

        if window.expand? &&
           (window.rows < (requested_rows + extra_padding) ||
            window.cols < (requested_cols + extra_padding))
          window.request_expansion requested_rows + extra_padding,
                                   requested_cols + extra_padding
        end
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
        c = CDK::SCROLL.new(window.cdk_scr,          # cdkscreen,
                        CDK::CENTER, CDK::CENTER,    # xplace, yplace, 
                        CDK::RIGHT,                  # scroll pos
                        window.rows-2,               # widget height
                        window.cols-3,               # widget width
                        @title, @items, @items.size, # title and items
                        false,                       # prefix numbers
                        Ncurses::A_REVERSE,          # highlight
                        true, false)                 # box, shadow

        pp = lambda do |cdktype, list, scroll_list, key|
          scroll_list.dispatch(:selected)
        end

        c.setPostProcess(pp, self)

        c
      end
    end # ScrollList
  end # module Components
end # module RETerm
