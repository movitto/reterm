module RETerm
  # Helper mixin defining standard navigation controls.
  # Used by layouts and top level components this tightly
  # defines keyboard navigation and allows the user to
  # seemlessly move between and activate/decativate
  # components.
  module NavInput
    include MouseInput

    # Key which if pressed causes the navigation component
    # to lose focus / become deactivated
    QUIT_CONTROLS  = [27, 'q'.ord, 'Q'.ord] # 27 = ESC

    # Key if pressed focuses on / activates a component
    ENTER_CONTROLS = [10] # 10 = enter , space

    # Up navigation keys
    UP_CONTROLS    = ['k'.ord, 'K'.ord, Ncurses::KEY_UP]

    # Down navigation keys
    DOWN_CONTROLS  = ['j'.ord, 'J'.ord, Ncurses::KEY_DOWN]

    # Left navigation keys
    LEFT_CONTROLS  = ['h'.ord, 'H'.ord, Ncurses::KEY_BACKSPACE,
                                        Ncurses::KEY_BTAB,
                                        Ncurses::KEY_LEFT]

    # Right navigation keys
    RIGHT_CONTROLS = ['l'.ord, 'L'.ord, "\t".ord, Ncurses::KEY_RIGHT]

    # All movement keys
    MOVEMENT_CONTROLS = UP_CONTROLS   + DOWN_CONTROLS +
                        LEFT_CONTROLS + RIGHT_CONTROLS

    # Used internally to specify component
    # which we should navigate to
    attr_accessor :nav_select

    # Return children which are focusabled/activable
    def focusable
      children.select { |c| c.activatable? }
    end

    # Return boolean indicating if any children are focusable
    def focusable?
      !focusable.empty?
    end

    # May be overridden by subclass to indicate if the
    # specified input / context is valid
    def valid_input?(ch, from_parent)
      true
    end


    # Helper to be internally invoked by navigation component
    # on activation
    def handle_input(from_parent=false)
      @focus ||= 0

      # focus on first component
      ch = handle_focused unless nav_select

      # Repeat until quit-sequence detected or app-shutdown
      while(!QUIT_CONTROLS.include?(ch) && !shutdown?)

        # Navigate to the specified component (nav_select)
        if self.nav_select 
          # it is a descendent of this one
          if self.contains?(self.nav_select)
            nav_to_selected

          # specified component is not a descendent,
          else
            nav_to_parent
            return nil
          end

        elsif ENTER_CONTROLS.include?(ch)
          focused.activate!

        elsif MOVEMENT_CONTROLS.include?(ch)
          handle_movement(ch, from_parent)

        elsif mev = process_mouse(ch)
          handle_mouse(mev)
        end

        return ch unless sanitize_focus!(from_parent)
        ch = handle_focused unless nav_select
      end

      ch
    end

    private

    def handle_movement(ch, from_parent)
      remove_focus
      return ch unless valid_input?(ch, from_parent)

      if UP_CONTROLS.include?(ch) ||
         LEFT_CONTROLS.include?(ch)
        @focus -= 1

      elsif DOWN_CONTROLS.include?(ch) ||
            RIGHT_CONTROLS.include?(ch)
        @focus += 1
      end
    end

    def focused
      focusable[@focus]
    end

    # Internal help, set the visual properties of the focused window
    def update_focus
      focused.window.border! unless !focused.highlight_focus?
      update_reterm
      window.root.draw!
    end

    # Internal helper, logic invoked when a component gains focus
    def handle_focused
      ch = nil

      update_focus

      focused.activate!(ENTER_CONTROLS.first) if focused.activate_focus?

      if focused.kind_of?(Layout)
        ch = focused.handle_input(true)

      else
        ch = window.sync_getch
      end

      ch
    end

    # Internal helper, logic invoked when a component loses focus
    def remove_focus
      focused.window.no_border!
    end

    # Internal helper, navigate to selected component under current
    def nav_to_selected
      # clear nav_select
      ns = self.nav_select
      self.nav_select = nil

      # specified component is a direct child
      if self.children.include?(ns)
        remove_focus
        @focus = focusable.index(ns)
        update_focus
        focused.activate!

      # not a direct child, navigate down to layout
      # containing it
      else
        child = self.layout_containing(ns)
        child.nav_select = ns
        ch = child.handle_input(true)
      end
    end

    # Internal helper, navigate to selected component up heirarchy
    def nav_to_parent
      # set selected component on the parent,
      # clear it locally, and
      # return to parent
      remove_focus
      ns = self.nav_select
      self.nav_select =  nil
      self.parent.nav_select = ns
    end

    # Internal helper, sanitize the focus tracker.
    # Return value indicates if sanity is preseved
    # in the context of this component (else we will
    # return to parent)
    def sanitize_focus!(from_parent)
      if @focus >= focusable.size
        @focus = focusable.size - 1
        return false if from_parent

      elsif @focus < 0
        @focus = 0
        return false if from_parent
      end

      true
    end

    def handle_mouse(mev)
      child = window.root.child_containing(mev.x, mev.y, mev.z)

      if child
        child = child.component

        if child.activatable?
          if self.contains?(child)
            nav_to_selected

          else
            self.nav_select = child
            nav_to_parent
            return nil
          end
        end
      end
    end
  end # module NavInput
end # module RETerm
