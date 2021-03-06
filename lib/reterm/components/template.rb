module RETerm
  module Components
    # Template which may be used as the basis for other components
    class Template < Component
      # All components must accept args hash (specified via loader)
      def initialize(args={})
        super
      end

      # Override this to request minimum rows
      # for window allocation
      def requested_rows
      end

      # Override this to request minimum cols
      # for window allocation
      def requested_cols
      end

      # Override this method to draw component on screen
      def draw!
      end

      # Return true if the user should be able to focus and
      # interact with this component, default to false
      def activatable?
      end

      # Method call when this component is activated
      def activate!(*input)
      end
    end # class Template
  end # module Components
end # module RETerm
