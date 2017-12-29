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

    # Helper to be internally invoked by navigation component
    # on activation
    def handle_input(from_parent=false)
      @focus ||= 0

      ch = handle_focused unless nav_select

      while(!QUIT_CONTROLS.include?(ch) && !shutdown?)
        if self.nav_select 
          if self.contains?(self.nav_select)
            ns = self.nav_select
            self.nav_select = nil

            if self.children.include?(ns)
              focused.window.no_border!
              @focus = focusable.index(ns)
              update_focus
              focused.activate!

            else
              child = self.layout_containing(ns)
              child.nav_select = ns
              ch = child.handle_input(true)
            end

          else
            focused.window.no_border!
            self.nav_select =  nil
            self.parent.nav_select = ns
            return nil
          end

        elsif ENTER_CONTROLS.include?(ch)
          focused.activate!

        elsif UP_CONTROLS.include?(ch)
          focused.window.no_border!

          return ch if window.component.is_a?(Layouts::Horizontal) &&
                       from_parent &&
                       !window.parent.children.index(window) != 0

          @focus -= 1

        elsif LEFT_CONTROLS.include?(ch)
          focused.window.no_border!

          return ch if window.component.is_a?(Layouts::Vertical) &&
                       from_parent &&
                       !window.parent.children.index(window) != 0

          @focus -= 1

        elsif DOWN_CONTROLS.include?(ch)
          focused.window.no_border!

          return ch if window.component.is_a?(Layouts::Horizontal) &&
                       from_parent &&
                       !window.parent.children.index(window) != (window.parent.children.size - 1)

          @focus += 1

        elsif RIGHT_CONTROLS.include?(ch)
          focused.window.no_border!

          return ch if window.component.is_a?(Layouts::Vertical) &&
                       from_parent &&
                       !window.parent.children.index(window) != (window.parent.children.size - 1)

          @focus += 1

        elsif mev = handle_mouse(ch)
          child = window.root.child_containing(mev.x, mev.y, mev.z)

          if child
            child = child.component
            if child.activatable?
              # if current window does not contain child,
              # set target component and return
              if child.window.parent != self.window
                focused.window.no_border!
                parent.nav_select = child
                return nil
              end

              focused.window.no_border!
              @focus = focusable.index(child)
              update_focus
              focused.activate!
            end
          end
        end

        if @focus >= focusable.size
          @focus = focusable.size - 1
          return ch if from_parent
        end

        if @focus < 0
          @focus = 0
          return ch if from_parent
        end

        ch = handle_focused unless nav_select
      end

      ch
    end

    private

    def focused
      focusable[@focus]
    end

    def update_focus
      focused.window.border! unless !focused.highlight_focus?
      update_reterm
      window.root.draw!
    end

    def handle_focused
      ch = nil

      update_focus

      if focused.kind_of?(Layout)
        ch = focused.handle_input(true)

      else
        ch = window.sync_getch
      end

      ch
    end
  end # module NavInput
end # module RETerm
