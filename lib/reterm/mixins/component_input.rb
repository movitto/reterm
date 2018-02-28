module RETerm
  # Helper mixin defining standard input controls for custom
  # components. 'In House' components included in the project
  # may used this to standarding their usage.
  module ComponentInput
    include CommonControls
    include CommonKeys

    # TODO include / incorporate MouseInput mixin
    # (scroll sliders/dials, click buttons, etc) ...

    # May be overridden in subclass, invoked when the user requests
    # an 'increment'
    def on_inc
    end

    # May be overridden in subclass, invoked when the user
    # requests a decrement
    def on_dec
    end

    # May be overridden in subclass, invoked when the user inputs
    # the enter key (unless quit_on_enter is true)
    def on_enter
    end

    # Helper to be internally invoked by component on activation
    def handle_input(*input)
      while ch = next_ch(input)
        quit  = QUIT_CONTROLS.include?(ch)
        enter = ENTER_CONTROLS.include?(ch)
        inc   = INC_CONTROLS.include?(ch)
        dec   = DEC_CONTROLS.include?(ch)

        break if shutdown? ||
                (quit && (!enter || quit_on_enter?))


        if key_bound?(ch)
          invoke_key_bindings(ch)

        elsif enter
          on_enter

        elsif inc
          on_inc

        elsif dec
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

    def next_ch(input)
      return sync_getch if input.empty?
      input.shift
    end

    def invoke_key_bindings(key)
      @bound_keys[key].each { |b| b.call self, key }
    end
  end # module ComponentInput
end # module RETerm
