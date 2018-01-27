module RETerm
  module NavControls
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

    # Quit when quit-sequence detected or app-shutdown
    def quit_nav?(ch=nil)
      (!ch.nil? && QUIT_CONTROLS.include?(ch) || shutdown? || deactivate?)
    end

    # Flag indicating that this component should
    # be deactivated
    def deactivate?
      !!(@deactivate ||= false)
    end

    # Make this component as decativated
    def deactivate!
      @deactivate = true
    end

    # Reset deactivation
    def reactivate!
      @deactivate = false
    end
  end # module NavControls
end # module RETerm
