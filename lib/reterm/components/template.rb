module RETerm
  module Components
    # Template which may be used as the basis for other components
    class Template < Component
      # All components must accept args hash (specified via loader)
      def initialize(args={})
      end

      # Override this method to draw component on screen
      def draw!
      end

      # Return true if the user should be able to focus and
      # interact with this component, default to false
      def activatable?
      end

      # Method call when this component is activated
      def activate!
      end
    end # class Template
  end # module Components
end # module RETerm
