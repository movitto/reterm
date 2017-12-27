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
        @widget  = args[:widget]
        @title   = args[:title] || ""
        @buttons = [args[:buttons]].flatten.compact

        @buttons = ["OK", "Cancel"] if @buttons.empty?
      end

      def requested_rows
        @widget.requested_rows + 6
      end

      def requested_cols
        [@title.size, total_button_size, @widget.requested_cols].max + 3
      end

      def window=(win)
        widget.window = win
        super(win)
      end

      def activate!
        component.draw(true)

        if widget.activatable?
          widget.activate!
        else
          super
        end

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

        w.setULchar(Ncurses::ACS_LTEE)
        w.setURchar(Ncurses::ACS_RTEE)

        # bind tab key to button box
        widget_cb = lambda do |widget, key|
          w.inject(key)
          return true
        end

        widget.bind_key(CDK::KEY_TAB, widget_cb)

        w
      end
    end # Dialog
  end # module Components
end # module RETerm
