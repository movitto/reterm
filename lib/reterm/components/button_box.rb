module RETerm
  module Components
    # CDK ButtonBox Component
    class ButtonBox < Component
      include CDKComponent
      include ButtonHelpers

      attr_accessor :widget

      # Initialize the ButtonBox component
      #
      # @param [Hash] args button box params
      # @option args [Component] :widget component
      #   to include in the button box
      # @option args [String] :title title
      #   to assign to button box
      # @option args [String, Array<String>] :buttons string
      #   buttons to assign to dialog
      #
      def initialize(args={})
        super
        @widget  = args[:widget]
        @title   = args[:title] || ""
        @buttons = [args[:buttons]].flatten.compact

        @buttons = ["OK", "Cancel"] if @buttons.empty?
      end

      def requested_rows
        @widget.requested_rows
      end

      def requested_cols
        [@title.size, total_button_size, @widget.requested_cols].max
      end

      def close!
        widget.erase
        widget.finalize!

        window.erase
        window.finalize!
      end

      def window=(win)
        super(win)
        cw = win.create_child :rows => widget.requested_rows,
                              :cols => [widget.requested_cols, requested_cols].max
        raise ArgumentError, "could not create child" if cw.win.nil?
        cw.component = widget
      end

      def activate!(*input)
        widget.draw!
        component.draw(true)

        if widget.activatable?
          widget.activate!(*input)
        else
          super
        end

        @buttons[component.current_button]
      end

      def selected
        @buttons[component.current_button]
      end

      private

      def _component
        w = CDK::BUTTONBOX.new(window.cdk_scr,
                               window.win.getbegx,
                               window.win.getbegy +
                               widget.window.rows - 1,
                               (@title.nil? || @title.empty?) ? 1 : 2, # height
                               widget.window.cols - 1, # width
                               @title,
                               1, 2, # rows / cols
                               @buttons, @buttons.size,
                               Ncurses::A_REVERSE, # highligh
                               true, false) # box, shadow

        widget.window.border!

        widget.component.setLLchar(Ncurses::ACS_LTEE) if widget.cdk? && widget.component.respond_to?(:setLLchar)
        widget.component.setLRchar(Ncurses::ACS_RTEE) if widget.cdk? && widget.component.respond_to?(:setLRchar)

        w.setULchar(Ncurses::ACS_LTEE)
        w.setURchar(Ncurses::ACS_RTEE)

        # bind tab/left/right key to button box
        widget_cb = lambda do |widget, key|
          w.inject(key)
          return true
        end

        # TODO allow specific keys overriding of specific keys to be disabled
        widget.bind_key(CDK::KEY_TAB, widget_cb)
        widget.bind_key(Ncurses::KEY_LEFT, widget_cb)
        widget.bind_key(Ncurses::KEY_RIGHT, widget_cb)

        w
      end
    end # Dialog
  end # module Components
end # module RETerm
