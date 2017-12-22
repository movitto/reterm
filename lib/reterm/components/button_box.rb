module RETerm
  module Components
    # CDK ButtonBox Component
    class ButtonBox < Component
      include CDKComponent

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

      def window=(win)
        widget.window = win
        super(win)
      end

      def activate!
        component.draw(true)
        widget.activate!
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

        widget.component.setLLchar(Ncurses::ACS_LTEE)
        widget.component.setLRchar(Ncurses::ACS_RTEE)
        w.setULchar(Ncurses::ACS_LTEE)
        w.setURchar(Ncurses::ACS_RTEE)

        # bind tab key to button box
        entry_cb = lambda do |cdktype, object, button_box, key|
          button_box.inject(key)
          return true
        end
        widget.component.bind(:ENTRY, CDK::KEY_TAB, entry_cb, w)

        w
      end
    end # Dialog
  end # module Components
end # module RETerm
