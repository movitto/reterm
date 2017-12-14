module RETerm
  # Helper mixin defining standard navigation controls.
  # Used by layouts and top level components this tightly
  # defines keyboard navigation and allows the user to
  # seemlessly move between and activate/decativate
  # components.
  module NavInput
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

    # Return children which are focusabled/activable
    def focusable
      children.select { |c| c.component.activatable? }
    end

    # Return boolean indicating if any children are focusable
    def focusable?
      !focusable.empty?
    end

    # Helper to be internally invoked by navigation component
    # on activation
    def handle_input(from_parent=false)
      @focus ||= 0

      ch = handle_focused

      while(!QUIT_CONTROLS.include?(ch))
        if ENTER_CONTROLS.include?(ch)
          focused.activate!

        elsif UP_CONTROLS.include?(ch)
          focused.no_border!

          return ch if window.component.is_a?(Layouts::Horizontal) &&
                       from_parent &&
                       !window.parent.children.index(window) != 0

          @focus -= 1

        elsif LEFT_CONTROLS.include?(ch)
          focused.no_border!

          return ch if window.component.is_a?(Layouts::Vertical) &&
                       from_parent &&
                       !window.parent.children.index(window) != 0

          @focus -= 1

        elsif DOWN_CONTROLS.include?(ch)
          focused.no_border!

          return ch if window.component.is_a?(Layouts::Horizontal) &&
                       from_parent &&
                       !window.parent.children.index(window) != (window.parent.children.size - 1)

          @focus += 1

        elsif RIGHT_CONTROLS.include?(ch)
          focused.no_border!

          return ch if window.component.is_a?(Layouts::Vertical) &&
                       from_parent &&
                       !window.parent.children.index(window) != (window.parent.children.size - 1)

          @focus += 1
        end

        if @focus >= focusable.size
          @focus = focusable.size - 1
          return ch if from_parent
        end

        if @focus < 0
          @focus = 0
          return ch if from_parent
        end

        ch = handle_focused
      end

      ch
    end

    private

    def focused
      focusable[@focus]
    end

    def handle_focused
      ch = nil

      focused.border! unless focused.component.kind_of?(Layout)
      update_reterm
      window.draw!

      if focused.component.kind_of?(Layout)
        ch = focused.component.handle_input(true)

      else
        ch = window.getch
      end

      ch
    end
  end # module NavInput
end # module RETerm
