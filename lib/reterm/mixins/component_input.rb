module RETerm
  # Helper mixin defining standard input controls for custom
  # components. 'In House' components included in the project
  # may used this to standarding their usage.
  module ComponentInput
    # Key which if pressed cause the component to
    # lose focus / become deactivated
    QUIT_CONTROLS = [10, 27] # 10 = enter, 27 = ESC

    # Keys if pressed invoked the increment operation
    INC_CONTROLS  = ['+'.ord, Ncurses::KEY_UP, Ncurses::KEY_RIGHT]

    # Keys if pressed invoked the decrement operation
    DEC_CONTROLS  = ['-'.ord, Ncurses::KEY_DOWN, Ncurses::KEY_LEFT]

    # May be overrideen in subclass, invoked when the user requests
    # an 'increment'
    def on_inc
    end

    # May be overrideen in subclass, invoked when the user
    # requests a decrement
    def on_dec
    end

    # Helper to be internally invoked by component on activation
    def handle_input
      while(!QUIT_CONTROLS.include?((ch = window.getch)))
        if INC_CONTROLS.include?(ch)
          on_inc
        elsif DEC_CONTROLS.include?(ch)
          on_dec
        end
      end
    end
  end # module ComponentInput
end # module RETerm
