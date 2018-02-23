module RETerm
  module Components
    # Splash Screen
    class Splash < Component
      attr_reader :widget, :callback

      # Initialize the Splash component
      #
      # @param [Hash] args splash params
      # @option args [Component] :widget component
      #   to include in the slash window
      def initialize(args={})
        super
        @widget    = args[:widget]
        @callback  = args[:callback]
        @terminate = false
      end

      # Client may invoke this to
      #   - create dialog and window
      #   - activate it
      #   - periodically invoke callback,
      #     check return value
      #   - close / cleanup
      def self.show(args={}, &bl)
        splash = self.new args.merge(:callback => bl)
        win    = Window.new args.merge(:component => splash,
                                       :x         => :center,
                                       :y         => :center)
        #win.component = splash
        splash.activate!
        update_reterm(true)
        splash.close!
      end

      def requested_rows
        @widget.requested_rows + 3
      end

      def requested_cols
        @widget.requested_cols + 3
      end

      def close!
        widget.erase
        widget.finalize!

        window.erase
        window.finalize!

        # get rid of all outstanding input
        flush_input
      end

      def sync!
        widget.sync!
      end

      def draw!
        window.border!
        widget.draw!
      end

      def window=(win)
        super(win)
        cw = win.create_child :rows => widget.requested_rows,
                              :cols => widget.requested_cols,
                              :x    => 1,
                              :y    => 1
        raise ArgumentError, "could not create child" if cw.win.nil?
        cw.component = widget
      end

      def activate!(*input)
        until @terminate
          window.draw!

          sleep SYNC_TIMEOUT.to_f / 1000
          run_sync!
          @terminate = !!callback.call
        end
      end
    end # class Splash
  end # module Components
end # module RETerm
