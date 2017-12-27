module RETerm
  # Mixin used by CDK based component defining cdk-specific helpers
  module CDKComponent
    # Should be implemented in subclass to initialize component
    def _component
      raise "NotImplemented"
    end

    # Return completely initialized CDK component
    def component
      enable_cdk!
      @component ||= begin
        c = _component
        c.setBackgroundColor("</#{@colors.id}>") if colored?
        c
      end
    end

    # Return boolean indicating if escape was hit
    def escape_hit?
      component.exit_type == :ESCAPE_HIT
    end

    # Return boolean indicating early exit occurred
    def early_exit?
      component.exit_type == :EARLY_EXIT
    end

    # Return boolean indicating if user selection made / normal
    # exit was invoked
    def normal_exit?
      component.exit_type == :NORMAL
    end

    # Assign {ColorPair} to component
    def colors=(c)
      super
      component.setBackgroundColor("</#{@colors.id}>")
    end

    # Invoke CDK draw routine
    def draw!
      component.draw([])
    end

    # CDK components may be activated
    def activatable?
      true
    end

    # Invoke CDK activation routine
    def activate!
      r = nil

      while component.exit_type == :NEVER_ACTIVATED
        r = component.activate([])
      end

      r
    end

    # Return stored value of cdk component
    def value
      component.getValue
    end

    # Bind key to specified callback
    def bind_key(key, kcb)
      cb = lambda do |cdktype, widget, component, key|
        kcb.call component, key
      end

      component.bind(:ENTRY, key, cb, self)
    end
  end # module CDKComponent
end # module RETerm
