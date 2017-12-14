module RETerm
  # Provides mechanism to orgranize on screen components according
  # to rules defined by subclasses.
  #
  # Layouts themselves are specialized types of components as they
  # are intended to be associated with windows in which to be rendered
  class Layout < Component
    include NavInput

    # TODO padding / margin support

    attr_accessor :children

    def initialize(args={})
      @children ||= []
    end

    # Subclasses should override this method returning
    # boolean if child window exceeds bounds of layout
    def exceeds_bounds?(child)
      raise "NotImplemented"
    end

    # Return boolean indicating if any child component
    # is activatable
    def activatable?
      children.any? { |c| c.component.activatable? }
    end

    # Create new child window and add it to layout
    def add_child(h={})
      child = window.create_child(h)

      if child.win.nil?
        raise ArgumentError, "could not create child window"
      end

      if exceeds_bounds?(child)
        window.del_child(child) unless child.win.nil?
        raise ArgumentError, "child exceeds bounds"
      end

      children << child
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
