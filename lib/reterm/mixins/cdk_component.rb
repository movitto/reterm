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
      component.activate([])
    end

    # Return stored value of cdk component
    def value
      component.getValue
    end
  end # module CDKComponent
end # module RETerm
