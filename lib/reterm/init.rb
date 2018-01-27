require 'ncursesw'
require_relative './resize'

module RETerm
  SYNC_TIMEOUT = 150 # in milliseconds if enabled

  ###############################

  # Initializes the RETerm subsystem before invoking block.
  # After block is finished regardless of execution state
  # (return, exception, etc) this will cleanup the terminal
  # environment before returning control to the TTY.
  #
  # This method is the first method the user should invoke
  # after requiring the reterm library.
  #
  # @example
  #   init_reterm {
  #     win = Window.new :rows => 20, :cols => 40
  #     # ... more UI logic
  #   }
  #
  def init_reterm(opts={}, &bl)
    @@shutdown = false

    begin
      Terminal.load # XXX: not sure why but loading terminal
                    #      info after changing terminal settings via
                    #      ncurses seems to corrupt the terminal
                    #      state to the point it cannot be restored
                    #      without a 'reset' (see below).
                    #      So just preload terminal info here.

      stdscr = Ncurses::initscr
      Ncurses::start_color
      Ncurses::noecho
      Ncurses::cbreak
      Ncurses::curs_set(0)  # TODO toggleable
      Ncurses::keypad(stdscr, true)
      #Ncurses::set_escdelay(100) # TODO

      no_mouse = opts[:nomouse] || (opts.key?(:mouse) && !opts[:mouse])
      Ncurses::mousemask(Ncurses::ALL_MOUSE_EVENTS | Ncurses::REPORT_MOUSE_POSITION, []) unless no_mouse

      track_resize if opts[:resize]

      bl.call

    #ensure
      stop_track_resize
      Ncurses.curs_set(1)
      Window.top.each { |w| w.finalize! }
      CDK::SCREEN.endCDK if cdk_enabled?
      Ncurses.endwin
      #`reset -Q` # XXX only way to guarantee a full reset (see above)
    end
  end

  # This method resyncs the visible terminal with the internal
  # RETerm environment. It should be called any time the user
  # needs to update the UI after making changes.
  #
  # @example
  #   init_reterm {
  #     win = Window.new
  #     win.border! # draw window border
  #     update_rti  # resync terminal ouput
  #     win.getch   # wait for input
  #   }
  #
  def update_reterm(force_refresh=false)
    if force_refresh
      Window.top.each { |w|
        w.erase
        w.draw!
      }
    else
      Window.top.each { |w| w.noutrefresh }
    end

    Ncurses::Panel.update_panels
    Ncurses.doupdate
  end

  # XXX Ncurses is exposed so that users
  # may employ any constants if desired.
  # This should not be needed though and
  # is discouraged to maintain portability
  NC = Ncurses

  ###############################

  # Enable the CDK subsystem. Used by CDKbased components
  #
  # @see #cdk_enabled?
  def enable_cdk!
    return if @cdk_enabled

    @cdk_enabled = true
    require 'cdk'

    # XXX defines standard color pairs, but we use our own
    # for standarization across components, but we need
    # to set cdk components to the correct color scheme
    # manually
    # CDK::Draw.initCDKColor
  end

  # Return boolean indicating if the CDK subsystem is enabled.
  # CDK is a library used by various components providing
  # many various ready to use ncurses widgets.
  def cdk_enabled?
    !!@cdk_enabled
  end

  ###############################

  # Enables the input timeout and component syncronization.
  #
  # Used internally by components that need to periodically
  # be updated outside of user input.
  def activate_sync!
    @@sync_activated = true
    Window.all.each { |w|
      w.win.timeout(SYNC_TIMEOUT)
    }
  end

  # Boonean indicating if component syncronization is
  # enabled
  def sync_enabled?
    defined?(@@sync_activated) && !!@@sync_activated
  end

  # Run the sync process, used internally
  def run_sync!
    return unless sync_enabled?

    Window.all.each { |w|
      w.sync!
    }

    update_reterm
  end

  ###############################

  # Use to halt all operation and cleanup.
  def shutdown!
    @@shutdown = true
  end

  # Boolean indicating if app in being halted
  def shutdown?
    !!@@shutdown
  end
end # module RETerm
