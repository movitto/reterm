module RETerm
  # Provides mechanism to orgranize on screen components according
  # to rules defined by subclasses.
  #
  # Layouts themselves are specialized types of components as they
  # are intended to be associated with windows in which to be rendered
  class Layout < Component
    include NavInput

    # Flag indicating if layout should expand
    # to be able to contain childen (if false
    # error will be throw if trying to add
    # child to layout that cannot contain it)
    attr_accessor :expand

    def expandable?
      (!defined?(@expand) || !!@expand) &&
      (!parent? || parent.expandable?)
    end

    def children
      window.children.collect { |w| w.component }
    end

    def empty?
      return true if window.nil?
      window.children.empty?
    end

    def child_windows
      window.children
    end

    def parent?
      window.parent?
    end

    def parent
      window.parent.component
    end

    # TODO padding / margin support

    # Subclasses should override this method returning
    # current rows in layout
    def current_rows
      raise "NotImplemented"
    end

    # Subclasses should override this method returning
    # current cols in layout
    def current_cols
      raise "NotImplemented"
    end

    # Subclasses should overrid this method returning
    # boolean indicating if boundries will be
    # exceeded when child is added
    def exceeds_bounds_with?(child)
      raise "NotImplemented"
    end

    # Returns boolean indicating if current layout
    # exceeds bounds of window
    def exceeds_bounds?
      current_cols > window.cols ||
      current_rows > window.rows
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
      return false if empty?
      children.any? { |c| c.activatable? }
    end

    def highlight_focus?
      false
    end

    # Create new child window and add it to layout
    def add_child(h={})
      c = nil

      if h.key?(:component)
        c = h[:component]

        h.merge! :rows => c.requested_rows + c.extra_padding,
                 :cols => c.requested_cols + c.extra_padding
      end

      raise ArgumentError, "must specify x/y" unless h.key?(:x) &&
                                                     h.key?(:y)

      raise ArgumentError, "must specify rows/cols" unless h.key?(:rows) &&
                                                           h.key?(:cols)

      # TODO should proporational percentage be of remaining area?
      h[:rows], h[:cols] = *Window.adjust_proportional(window, h[:rows], h[:cols])
      h[:x],    h[:y]    = *Window.align(window, h[:x], h[:y], h[:rows], h[:cols])

      if h[:fill]
        p = parent? ? parent.window : Terminal
        if (h[:y] + h[:rows]) < p.rows
          h[:rows] = p.rows-h[:y]-4 # FIXME: 4 = extrapadding + 1 (?)
        end

        if (h[:x] + h[:cols]) < p.cols
          h[:cols] = p.cols-h[:x]-4
        end
      end

      if exceeds_bounds_with?(h)
        if expandable? # ... && can_expand_to?(h)
          expand(h)

        else
          raise ArgumentError, "child exceeds bounds"

        end
      end

      child = window.create_child(h)

      # TODO need to reverse expansion if operation fails at any
      # point on, or verify expandable before create_child but
      # do not expand until after

      if child.win.nil?
        raise ArgumentError, "could not create child window"
      end

      if exceeds_bounds?
        window.del_child(child) unless child.win.nil?
        raise ArgumentError, "child exceeds bounds"
      end

      child.component = c unless c.nil?

      update_reterm
      child
    end

    def expand(h)
      nr = [current_rows, h[:y] + h[:rows]].max
      nc = [current_cols, h[:x] + h[:cols]].max

      # verify parent can contain expanded area and is expandable
      if parent?
        if parent.exceeds_bounds_with?(h)
          raise ArgumentError, "cannot expand parent" unless parent.expandable?

          # expand parent
          parent.expand(h)
        end
      end

      # perform actual window expansion
      window.resize(nr+1, nc+1)

      # FIXME need to expand children who are marked as 'fill'
    end

    # Draw all layout children
    def draw!
      children.each { |c| c.draw! }
      draw_focus!
    end

    # Activates layout by dispatching to navigation
    # input system.
    #
    # @see NavInput
    def activate!(*input)
      draw!
      update_reterm
      handle_input(*input)
    end
  end # class Layout
end # module RETerm
