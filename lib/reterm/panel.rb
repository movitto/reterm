module RETerm
  # Panels provide quick ways to switch between menus, pushing and
  # poping them on/off an internal stack
  class Panel
    include EventDispatcher

    # Initialize panel from the given window.
    #
    # This maintains an internal registry of panels created
    # for event dispatching purposes
    def initialize(window)
      @@registry ||= {}

      # panel already associated with window
      raise ArgumentError, window if @@registry.key?(window)

      @@registry[window] = self

      @window = window
      @panel  = Ncurses::Panel::PANEL.new(@window.win)
    end

    # Render this panel by surfacing it ot hte top of the stack
    def show
      Ncurses::Panel.top_panel(@panel)
      update_reterm

      @@registry.values.each { |panel|
        if panel == self
          dispatch :panel_show
        else
          panel.dispatch :panel_hide
        end
      }
    end
  end # class Panel
end # module RETerm
