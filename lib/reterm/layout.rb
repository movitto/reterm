module RETerm
  # Provides mechanism to orgranize on screen components according
  # to rules defined by subclasses.
  #
  # Layouts themselves are specialized types of components as they
  # are intended to be associated with windows in which to be rendered
  class Layout < Component
    include NavInput

    def children
      window.children.collect { |w| w.component }
    end

    def child_windows
      window.children
    end

    def parent
      window.parent.component
    end

    # TODO padding / margin support

    # Subclasses should override this method returning
    # boolean if current layout exceeds bounds of window
    def exceeds_bounds?
      raise "NotImplemented"
    end

    # Return layout containing component
    # If coordinates are contained in a child in current layout
    def layout_containing(component)
      return self if children.include?(component)

      found = nil
      children.each { |c|
        next if found

        if c.kind_of?(Layout)
          found = c unless c.layout_containing(component).nil?
        end
      }

      found
    end

    # Return boolean indicating if layout contains specified child
    def contains?(child)
      children.any? { |c|
        (c.kind_of?(Layout) && c.contains?(child)) || c == child
      }
    end

    # Return boolean indicating if any child component
    # is activatable
    def activatable?
      children.any? { |c| c.activatable? }
    end

    # Create new child window and add it to layout
    def add_child(h={})
      child = window.create_child(h)

      if child.win.nil?
        raise ArgumentError, "could not create child window"
      end

      if exceeds_bounds?
        window.del_child(child) unless child.win.nil?
        raise ArgumentError, "child exceeds bounds"
      end

      update_reterm
      child
    end

    # Draw all layout children
    def draw!
      children.each { |c| c.draw! }
    end

    # Activates layout by dispatching to navigation
    # input system.
    #
    # @see NavInput
    def activate!
      draw!
      update_reterm
      handle_input
    end
  end # class Layout
end # module RETerm
