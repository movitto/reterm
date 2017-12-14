module RETerm
  # Graphical menu rendered on screen
  #
  # TODO: look into working this into std component/activation subsystem
  class Menu
    include EventDispatcher

    attr_accessor :window

    # Menus should be instantiated with a hash of label/value
    # pairs to assign to menu
    def initialize(items={})
      @items = items
      @menu  = Ncurses::Menu.new_menu(items.collect { |k,v|
                 Ncurses::Menu.new_item(k.to_s, v.to_s)
               })

      @menu.menu_opts_off(Ncurses::Menu::O_SHOWDESC)
    end

    # Return number of rows in menu
    def rows
      @items.size
    end

    # Return number of cols in menu
    def cols
      @cols ||= @items.keys.max { |k| k.size }.size + 3
    end

    # Attach menu to specified window
    def attach_to(win)
      @menu.set_menu_win(win.win)
      win.component = self

      @child_win = win.create_child :rows => rows,
                                    :cols => cols,
                                    :x => 1, :y => 1
      @menu.set_menu_sub(@child_win.win)
      @menu.post_menu

      self
    end

    # Destroy menu subsystem
    def detach
      @menu.unpost_menu
    end

    def finalize!
    end

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

    # Drive menu from input
    def drive(i)
      i = driver_map[i] if i.is_a?(Symbol)
      Ncurses::Menu.menu_driver(@menu, i)
    end
  end # class Menu
end # module RETerm
