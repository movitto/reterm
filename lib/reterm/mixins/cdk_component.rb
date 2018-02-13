module RETerm
  # Mixin used by CDK based component defining cdk-specific helpers
  module CDKComponent
    def init_cdk(args={})
      self.title_attrib = args[:title_attrib] if args.key?(:title_attrib)
    end

    def title_attrib=(a)
      @title_attrib = a
      component.title_attrib = a if defined?(@component)
    end

    # Boolean indicating this component is a cdk component
    def cdk?
      true
    end

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
        c.timeout(SYNC_TIMEOUT) if sync_enabled? # XXX
        c.title_attrib = @title_attrib if @title_attrib
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

    def erase
      component.erase
    end

    # CDK components may be activated
    def activatable?
      true
    end

    # Invoke CDK activation routine
    def activate!(*input)
      dispatch :activated
      component.resetExitType

      r = nil

      while [:EARLY_EXIT, :NEVER_ACTIVATED, :TIMEOUT].include?(component.exit_type) &&
            !shutdown?
        r = component.activate(input)
        run_sync! if sync_enabled?
      end

      dispatch :deactivated
      r
    end

    def deactivate!
      component.activate [CDK::KEY_ESC]
      dispatch :deactivated
    end

    # Return stored value of cdk component
    def value
      component.getValue
    end

    # Override bind_key to use cdk bindings mechanism
    def bind_key(key, kcb=nil, &bl)
      kcb = bl if kcb.nil? && !bl.nil?

      cb = lambda do |cdktype, widget, component, key|
        kcb.call component, key
      end

      component.bind(:ENTRY, key, cb, self)
    end
  end # module CDKComponent
end # module RETerm
