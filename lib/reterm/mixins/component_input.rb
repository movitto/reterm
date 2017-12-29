module RETerm
  # Helper mixin defining standard input controls for custom
  # components. 'In House' components included in the project
  # may used this to standarding their usage.
  module ComponentInput
    # TODO include / incorporate MouseInput mixin
    # (scroll sliders/dials, click buttons, etc) ...

    # Key which if pressed cause the component to
    # lose focus / become deactivated
    QUIT_CONTROLS = [10, 27] # 10 = enter, 27 = ESC

    # Keys if pressed invoked the increment operation
    INC_CONTROLS  = ['+'.ord, Ncurses::KEY_UP, Ncurses::KEY_RIGHT]

    # Keys if pressed invoked the decrement operation
    DEC_CONTROLS  = ['-'.ord, Ncurses::KEY_DOWN, Ncurses::KEY_LEFT]

    # TODO page/scroll controls

    # May be overridden in subclass, invoked when the user requests
    # an 'increment'
    def on_inc
    end

    # May be overridden in subclass, invoked when the user
    # requests a decrement
    def on_dec
    end

    # Helper to be internally invoked by component on activation
    def handle_input
      while(!QUIT_CONTROLS.include?((ch = window.sync_getch)) && !shutdown?)
        if key_bound?(ch)
          invoke_key_bindings(ch)

        elsif INC_CONTROLS.include?(ch)
          on_inc
        elsif DEC_CONTROLS.include?(ch)
          on_dec
        end
      end
    end

    def bind_key(key, kcb)
      @bound_keys      ||= {}
      @bound_keys[key] ||= []
      @bound_keys[key]  << kcb
      nil
    end

    def key_bound?(key)
      @bound_keys ||= {}
      @bound_keys.key?(key)
    end

    private

    def invoke_key_bindings(key)
      @bound_keys[key].each { |b| b.call self, key }
    end
  end # module ComponentInput
end # module RETerm
