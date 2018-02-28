module RETerm
  module CommonKeys
    # Key which if pressed cause the component to
    # lose focus / become deactivated
    QUIT_CONTROLS = [10, 27, Ncurses::KEY_ENTER] # 10 = enter, 27 = ESC

    ENTER_CONTROLS = [10, Ncurses::KEY_ENTER] # quit controls with out esc

    # Keys if pressed invoked the increment operation
    INC_CONTROLS  = ['+'.ord, Ncurses::KEY_UP, Ncurses::KEY_RIGHT]

    # Keys if pressed invoked the decrement operation
    DEC_CONTROLS  = ['-'.ord, Ncurses::KEY_DOWN, Ncurses::KEY_LEFT]

    # TODO add page/scroll controls
  end # module CommonKeys
end # module CDK
