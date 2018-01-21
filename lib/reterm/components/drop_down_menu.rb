module RETerm
  module Components
    # CDK Drop Down Menu Component
    class DropDownMenu < Component
      include CDKComponent

      # Initialize the Menu component
      #
      # @param [Hash] args menu params
      # @option args [Array<Hash<String, Symbol>>] :menus array of menus,
      #   each an hash of item labels / values
      # @option args [Array<Symbol>] :locs locations of menus
      # @option args [Symbol] :pos menu position (default top)
      # @option args [ColorPair] :color color to assign to drop down
      #   menu items
      # @option args [ColorPair] :backound color pair to assign to
      #   menu bar background color
      def initialize(args={})
        super
        @menus = args[:menus] || []
        @locs  = args[:locs]  || 0.upto(size-1).collect { :left }
        @pos   = args[:pos]   || :top
        @color = args[:color]
        @background = args[:background]

        @prev = nil
      end

      def background?
        !!@background
      end

      def finalize!
        @bgwin.finalize! if background?
      end

      def menu_list
        @menus.collect { |m| m.keys }
      end

      def colored_menu_list
        return menu_list unless !!@color
        menu_list.collect { |ms| ms.collect { |m| "#{@color.cdk_fmt}#{m}" }}
      end

      def size
        @menus.size
      end

      def requested_cols
        total_cols + total_sp + 3
      end

      def requested_rows
        max_items + 2
      end

      def draw!
        super
        @bgwin.mvaddstr(0, 0, ' ' * requested_cols) if background?
      end

      def window=(w)
        win = super(w)

        # add a window to render menu bar background
        if background?
          c = win.create_child :x    => 0,
                               :y    => 0,
                               :rows => 1,
                               :cols => requested_cols - 2
          c.colors = @background
          @bgwin = c
        end

        win
      end

      def submenu_sizes
        @menus.collect { |m| m.size }
      end

      def selected
        @menus[component.current_title][@menus[component.current_title].keys[component.current_subtitle+1]]
      end

      def activate!(*input)
        r = super
        return nil if early_exit?
        m = r / 100
        i = r % 100

        @menus[m][@menus[m].keys[i+1]]
      end

      def highlight_focus?
        false
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
                        colored_menu_list, size,
                        submenu_sizes,
                        locs, pos,
                        Ncurses::A_UNDERLINE,
                        Ncurses::A_REVERSE)

        m = self
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
