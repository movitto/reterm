module RETerm
  module Components
    # NCurses Menu Component
    class Menu < Component
      include ComponentInput
      include ItemHelpers

      # Initialize the Menu component
      #
      # @param [Hash] args menu params
      # @option args [Hash] :items hash of title/value pairs
      #   of menu items
      def initialize(args={})
        @items = args[:items] || {}
      end

      def requested_rows
        @items.size
      end

      def requested_cols
        [max_item_size, 20].max + 2
      end


      # Override window setter
      def window=(win)
        super(win)
        menu.set_menu_win(win.win)
        @child_win = win.create_child :rows => rows,
                                      :cols => cols,
                                      :x => 1, :y => 1
        menu.set_menu_sub(@child_win.win)
        menu.post_menu
        win
      end

      def finalize!
        menu.unpost_menu
      end

      def draw!
        menu.win.refresh
      end

      def activatable?
        true
      end

      def activate!(*input)
        menu.win.refresh
        handle_input(*input)
        menu.current_item.name
      end

      def rows
        @items.size
      end

      # Return number of cols in menu
      def cols
        @cols ||= @items.keys.max { |k| k.size }.size + 3
      end

      private

      # Static map of menu drivers to internal representations.
      #
      # XXX defined here (as opposed to a const) since these
      # consts won't be available until after init_scr
      def driver_map
        @driver_map ||= {
          :left          => Ncurses::Menu::REQ_LEFT_ITEM,
          :right         => Ncurses::Menu::REQ_RIGHT_ITEM,
          :up            => Ncurses::Menu::REQ_UP_ITEM,
          :down          => Ncurses::Menu::REQ_DOWN_ITEM,
          :scr_up_line   => Ncurses::Menu::REQ_SCR_ULINE,
          :scr_down_line => Ncurses::Menu::REQ_SCR_DLINE,
          :scr_down_page => Ncurses::Menu::REQ_SCR_DPAGE,
          :scr_up_page   => Ncurses::Menu::REQ_SCR_UPAGE,
          :first         => Ncurses::Menu::REQ_FIRST_ITEM,
          :last          => Ncurses::Menu::REQ_LAST_ITEM,
          :next          => Ncurses::Menu::REQ_NEXT_ITEM,
          :prev          => Ncurses::Menu::REQ_PREV_ITEM,
          :toggle        => Ncurses::Menu::REQ_TOGGLE_ITEM
        }
      end


      def on_inc
        Ncurses::Menu.menu_driver(@menu, driver_map[:up])
      end

      def on_dec
        Ncurses::Menu.menu_driver(@menu, driver_map[:down])
      end

      def menu
        @menu ||= begin
          m = Ncurses::Menu.new_menu(@items.collect { |k,v|
                Ncurses::Menu.new_item(k.to_s, v.to_s)
              })

          m.menu_opts_off(Ncurses::Menu::O_SHOWDESC)
          m
        end
      end
    end # Menu
  end # module Components
end # module RETerm
