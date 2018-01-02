module RETerm
  # A Component is a generic widget container associated with a window.
  # Subclasses each implement a specific UI artifact.
  class Component
    include LogHelpers

      attr_accessor :window

      # This method is invoked when adding component to layout
      # to determine rows needed
      def requested_rows
        1
      end

      # This method is invoked when adding component to layout
      # to determine cols needed
      def requested_cols
        1
      end

      # This method is invoked to cleanup the component on shutdown.
      # It should be be overriden by subclasses that needs to clean
      # resources before being deallocated
      def finalize!
      end

      # Return a boolean indicating if a {ColorPair} has been
      # assign to component
      def colored?
        !!@colors
      end

      # Assign the specified {ColorPair} to the component
      def colors=(c)
        @colors = c
      end

      # Returns a boolean indicating if the user should be
      # able to focus on and activate the component. By default
      # this is false, but interactive components should override
      # and return true.
      def activatable?
        false
      end

      # Actual activation mechanism, invoked by the navigation
      # logic when the user has selected an activatable? component.
      # Should be overriden by interactive subcomponents to
      # process user inpute specific to that component
      def activate!
        raise RuntimeError, "should not be activated"
      end

      # Return boolean indicating if this component should
      # be highlighted on focus
      def highlight_focus?
        true
      end

      # Return extra padding to be given to component
      def extra_padding
        (activatable? && highlight_focus?) ? 3 : 0
      end

      # Method to periodically synchronize component if needed
      def sync!
      end

      # Dispatch to window.resize
      def resize(rows, cols)
        window.resize(rows, cols)
        self
      end

      # Overridden by CDK components
      def cdk?
        false
      end
  end # class Component
end # module RETerm
