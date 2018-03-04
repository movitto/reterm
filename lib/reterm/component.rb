module RETerm
  # A Component is a generic widget container associated with a window.
  # Subclasses each implement a specific UI artifact.
  class Component
    include EventDispatcher
    include LogHelpers
    include KeyBindings

      attr_reader :window

      def window=(w)
        @window = w
        dispatch(:window_assigned)
        w
      end

      def initialize(args={})
        self.highlight_focus = args[:highlight_focus] if args.key?(:highlight_focus)
        self.activate_focus  = args[:activate_focus]  if args.key?(:activate_focus)
        init_cdk(args) if cdk?
      end

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
      def activate!(*input)
        raise RuntimeError, "should not be activated"
      end

      # This method is invoked when component loses focus
      # (when navigating to another component, window closed, etc).
      # Subclasses may override to hide / cleanup resources
      def deactivate!
      end

      attr_writer :highlight_focus

      # Return boolean indicating if this component should
      # be highlighted on focus (default true)
      def highlight_focus?
        !defined?(@highlight_focus) || @highlight_focus
      end

      attr_writer :activate_focus

      def activate_focus?
        defined?(@activate_focus) && @activate_focus
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

      def sync_getch
        c = window.sync_getch
        c = nil if key_bound?(c) &&
                   invoke_key_bindings(c)
        c
      end
  end # class Component
end # module RETerm
