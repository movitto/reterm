module RETerm
  # Windows are areas rendered on screen, associated with components
  # to be rendered in them. They specify the position to start drawing
  # component as well as the maximum width and height. A border may be
  # drawn around a window and a {ColorPair} associated.
  #
  # If Layout is added to a Window, children may subsequently be added.
  # This should be performed via the Layout#add_child method.
  #
  # @example adding a layout to a window
  #   init_reterm {
  #     win = Window.new :rows => 50, :cols => 30
  #     layout = Layouts::Horizontal.new
  #     win.component = layout
  #
  #     child = layout.add_child :rows => 5, :cols => 10
  #     child.class # => RETerm::Window
  #
  #     label = Components::Label.new :text => "Hello World!"
  #     child.component = label
  #
  #     update_reterm
  #     sleep(5)
  #   }
  #
  class Window
    include EventDispatcher
    include LogHelpers

    attr_reader :window_id

    attr_accessor :rows, :cols
    attr_accessor :x,    :y

    attr_accessor :vborder
    attr_accessor :hborder

    attr_accessor :component

    attr_reader :win

    attr_reader :parent
    attr_accessor :children

    # Return bool indicating if this window has a component
    # associated with it
    def component?
      !!@component
    end

    # Assign component to window. This will autoassign local
    # window to component as well.
    def component=(c)
      c.window   = self
      c.colors   = @colors if colored?
      @component = c
    end

    # Return boolean if this window is a child of another
    def parent?
      !!@parent
    end

    # Return root window (recusively), self if parent is not set
    def root
      parent? ? parent.root : self
    end

    def total_x
      @tx ||= parent? ? (parent.total_x + x) : x
    end

    def total_y
      @ty ||= parent? ? (parent.total_y + y) : y
    end

    # Instantiate Window with given args. None are required, but
    # unless :rows, :cols, :x, or :y is specified, window will be
    # created in it's default position.
    #
    # This method will generate a unique id for each window
    # and add it to a static registery for subsequent tracking.
    #
    # @param [Hash] args arguments used to instantiate window
    # @option args [Integer] :rows number of rows to assign to window
    # @option args [Integer] :cols number of cols to assign to window
    # @option args [Integer] :x starting x position of window
    # @option args [Integer] :y starting y position of window
    # @option args [Integer] :vborder vertical border char
    # @option args [Integer] :hborder horizontal border char
    # @option args [Component] :component component to assign to window
    # @option args [Window] :parent parent to assign to window, if
    #   set window will be created a a child, else it will be
    #   independently created & tracked.
    # @options args [Boolean] :expand bool indicating
    #   if window can be expanded on request
    # @options args [Boolean] :must_expand bool indicating
    #   if window must be expanded when requested. Failure
    #   to expand will result in an error
    # @options args [Boolean] :fill bool indicating
    #   if window should fill remaining space
    #
    def initialize(args={})
      @@registry ||= []
      @@registry  << self

      @rows = args[:rows] || (Terminal.rows - 1)
      @cols = args[:cols] || (Terminal.cols - 1)

      raise ArgumentError,
        "terminal too small" unless Terminal.contains?(@rows, @cols)

      @x    = args[:x] || 0
      @y    = args[:y] || 0

      # ... center & other const support
      # (use cdk if enabled, else calculate ourself)
      # https://github.com/jaromil/MuSE/blob/master/src/ncursesgui/libcdk/cdk.h#L186

      @vborder = args[:vborder] || 0
      @hborder = args[:hborder] || 0

      self.component = args[:component] if args.key?(:component)

      if args[:parent]
        @parent = args[:parent]
        @win = parent.win.derwin(@rows, @cols, @y, @x)

      else
        @parent = nil
        @win = Ncurses::WINDOW.new(@rows, @cols, @y, @x)
      end

      Ncurses::keypad(@win, true)

      @win.timeout(SYNC_TIMEOUT) if @win && sync_enabled? # XXX

      @children = []

      @expand      = !!args[:expand]
      @must_expand = !!args[:must_expand]

      @fill        = !!args[:fill]

      @@wid ||= 0
      @@wid  += 1

      @window_id = @@wid
    end

    # Invoke window finalization routine by destroying it
    # and all children
    def finalize!
      children.each { |c|
        del_child c
        cdk_scr.destroy if cdk?
        component.finalize! if component?
      }
    end

    ###

    def expand?
      !!@expand
    end

    def must_expand?
      !!@must_expand
    end

    def request_expansion(r, c)
      h = {:rows => r,
           :cols => c,
           :x    => x,
           :y    => y}

      if parent?
        if parent.component.exceeds_bounds_with?(h)
          if parent.component.expandable?
            parent.component.expand(h)

          else
            raise ArgumentError, "cannot expand" if must_expand?
            return false
          end
        end

      else
        unless Terminal.contains?(h)
          raise ArgumentError, "terminal too small" if must_expand?
          return false
        end
      end

      resize(r, c)
      true
    end

    ###

    # Return cdk screen (only used by CDK components)
    def cdk_scr
      enable_cdk!
      @cdk_scr ||= CDK::SCREEN.new(@win)
    end

    # Return bool indicating if cdk is enabled for this window/component
    def cdk?
      !!@cdk_scr
    end

    ###

    # Static method returning all tracked windows
    def self.all
      @@registry ||= []
      @@registry
    end

    # Static method returning top level windows
    def self.top
      @@registry ||= []
      @@registry.select { |w| !w.parent? }
    end

    ###

    # Create child window, this method should not be invoked
    # by end-user, rather it is is invoked the Layout#add_child
    # is called.
    def create_child(h={})
      c = self.class.new h.merge(:parent => self)
      c.colors = @colors if colored?
      children << c
      c
    end

    # Remove child window, like #create_child, this is used internally
    # and should not be invoked by the end user
    def del_child(child)
      @children.delete(child)
      @@registry.delete(child)
      child.finalize!
      child.win.delwin
    end

    # Return child containing specified screen coordiantes, else nil
    def child_containing(x, y, z)
      found = nil
      children.find { |c|
        next if found

        # recursively descend into layout children
        if c.component.kind_of?(Layout)
          found = c.child_containing(x, y, z)

        else
          found =
            c.total_x <= x && c.total_y <= y && # c.z >= z
           (c.total_x + c.cols) >= x && (c.total_y + c.rows) >= y
          found = c if found
        end
      }

      found
    end

    ###

    def resize(rows, cols)
      r = win.resize rows, cols
      raise ArgumentError, "could not resize window" if r == -1

      @rows = rows
      @cols = cols

      self
    end

    ###

    # Clear window by removing all children and reinitializing window space
    def clear!
      children.each { |c|
        del_child(c)
      }

      @children = []
      erase
    end

    # Erase window drawing area
    def erase
      @win.werase
    end

    # Refresh / resynchronize window and all children
    def refresh
      @win.refresh
      children.each { |c|
        c.refresh
      }
    end

    # Remove Border around window
    def no_border!
      @win.border(' '.ord, ' '.ord, ' '.ord, ' '.ord, ' '.ord, ' '.ord, ' '.ord, ' '.ord)
    end

    # Draw Border around window
    def border!
      @win.box(@vborder, @hborder)
    end

    # Blocking call to capture next character from window
    def getch
      @win.getch
    end

    # Normal getch unless sync enabled in which case,
    # timeout will be checked & components synchronized
    def sync_getch
      return self.getch unless sync_enabled?

      c = -1
      while c == -1 && !shutdown?
        c = self.getch
        run_sync!
      end

      c
    end

    # Dispatch to component synchronization
    def sync!
      component.sync!
      children.each { |c|
        c.sync!
      }
    end

    # Write string at specified loc
    def mvaddstr(*a)
      @win.mvaddstr(*a)
    end

    # Return bool indiciating if colors are set
    def colored?
      !!@colors
    end

    # Set window color
    def colors=(c)
      @colors = c.is_a?(ColorPair) ? c : ColorPair.for(c)
      @win.bkgd(Ncurses.COLOR_PAIR(@colors.id)) unless @win.nil?

      component.colors = @colors if component?

      children.each { |ch|
        ch.colors = c
      }
    end

    # Return window dimensions as an array containing rows & cols
    def dimensions
      rows = []
      cols = []
      @win.getmaxyx(rows, cols)
      rows = rows.first
      cols = cols.first
      [rows, cols]
    end

    # Return window rows
    def actual_rows
      dimensions[0]
    end

    # Return window cols
    def actual_cols
      dimensions[1]
    end

    # Draw component in window
    def draw!
      component.draw! if component?
    end

    # Activate window component
    def activate!
      component.activate!
    end
  end
end # module RETerm
