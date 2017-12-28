module RETerm
  module Components
    # CDK Drop Down Menu Component
    class DropDownMenu < Component
      include EventDispatcher
      include CDKComponent

      # Initialize the Menu component
      #
      # @param [Hash] args menu params
      # @option args [Array<Hash<String, Symbol>>] :menus array of menus,
      #   each an hash of item labels / values
      # @option args [Array<Symbol>] :locs locations of menus
      # @option args [Symbol] :pos menu position (default top)
      def initialize(args={})
        @menus = args[:menus] || []
        @locs  = args[:locs]  || 0.upto(size-1).collect { :left }
        @pos   = args[:pos]   || :top
      end

      def menu_list
        @menus.collect { |m| m.keys }
      end

      def size
        @menus.size
      end

      def requested_cols
        total_cols + total_sp
      end

      def requested_rows
        max_items
      end

      def submenu_sizes
        @menus.collect { |m| m.size }
      end

      def current
        @menus[component.current_title][@menus[component.current_title].keys[component.current_subtitle+1]]
      end

      def activate!
        r = super
        return nil if early_exit?
        m = r / 100
        i = r % 100

        @menus[m][@menus[m].keys[i+1]]
      end

      private

      def total_cols
        menu_list.sum { |m| m.first.size }
      end

      def total_sp
        menu_list.size - 1
      end

      def max_items
        @menus.max { |m1, m2| m1.size <=> m2.size }.size
      end

      def _component
        locs  = @locs.collect { |l| (l == :left) ? CDK::LEFT  :
                                    (l == :right ? CDK::RIGHT : l)}
        pos   = (@pos == :top)    ? CDK::TOP    :
                (@pos == :bottom) ? CDK::BOTTOM : @pos

        c = CDK::MENU.new(window.cdk_scr,
                        menu_list, size,
                        submenu_sizes,
                        locs, pos,
                        Ncurses::A_UNDERLINE,
                        Ncurses::A_REVERSE)

        callback = lambda do |cdktype, menu, component, key|
          component.dispatch :changed
        end

        c.setPostProcess(callback, self)

        c
      end
    end # class DropDownMenu

    DropDown = DropDownMenu
  end # module Components
end # module RETerm
