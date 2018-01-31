module RETerm
  module MouseInput
    ALL_EVENTS = Ncurses::ALL_MOUSE_EVENTS |
                 Ncurses::REPORT_MOUSE_POSITION

    MOUSE_MAP = {
      :PRESSED        => :pressed,
      :RELEASED       => :released,
      :CLICKED        => :click,
      :DOUBLE_CLICKED => :dclick,
      :TRIPLE_CLICKED => :tclick,
    }

    def mouse_paste?
      !!reterm_opts[:mouse_paste]
    end

    # May be overridden in subclass, invoked when
    # the user interacts with a button.
    #
    # @param [Integer] b number of the button that was invoked
    # @param [Symbol] evnt button event, may be :press, :release,
    #   :click, :dclick (double click), :tclick (triple click)
    def on_button(b, evnt, coords)
      #puts "B#{b} #{evnt}, #{coords}"
    end

    def process_mouse(ch)
      return nil unless ch == Ncurses::KEY_MOUSE

      mev = Ncurses::MEVENT.new
      Ncurses.getmouse(mev)

      if mev.bstate == Ncurses::BUTTON2_CLICKED && mouse_paste?
        # TODO grab clipboard buffer & return character array
        #   (need to handle seperately in invoker)
        #
        # use https://github.com/janlelis/clipboard
        # but note this requires external programs!
      end

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
