module RETerm
  module MouseInput
    MOUSE_MAP = {
      :PRESSED        => :pressed,
      :RELEASED       => :released,
      :CLICKED        => :click,
      :DOUBLE_CLICKED => :dclick,
      :TRIPLE_CLICKED => :tclick,
    }

    # May be overridden in subclass, invoked when
    # the user interacts with a button.
    #
    # @param [Integer] b number of the button that was invoked
    # @param [Symbol] evnt button event, may be :press, :release,
    #   :click, :dclick (double click), :tclick (triple click)
    def on_button(b, evnt, coords)
      #puts "B#{b} #{evnt}, #{coords}"
    end

    def handle_mouse(ch)
      return nil unless ch == Ncurses::KEY_MOUSE

      mev = Ncurses::MEVENT.new
      Ncurses.getmouse(mev)
      # TODO 5 button support (requiest "--enable-ext-mouse" ncurses flag
      # which is not specified in many major distrubtions)
      1.upto(4).each { |b|
        MOUSE_MAP.each { |n, e|
          if mev.bstate == Ncurses.const_get("BUTTON#{b}_#{n}")
            x,y,z = mev.x, mev.y, mev.z
            on_button(b, e, [x,y,z])
          end
        }
      }

      # TODO wrap MEVENT w/ our own class,
      # w/ high levels helpers for buttons, coords, etc
      mev
    end
  end # module MouseInput
end # module RETerm
