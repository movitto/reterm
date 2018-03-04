module RETerm
  module Components
    # CDK Dialog Component
    class Dialog < Component
      include CDKComponent

      attr_reader :buttons

      BUTTONS = {
        :ok        => ["</B/24>OK"],
        :ok_cancel => ["</B/24>OK", "</B16>Cancel"]
      }

      # Initialize the Dialog component
      #
      # @param [Hash] args dialog params
      # @option args [String, Array<String>] :message string
      #   message(s) to assign to dialog
      # @option args [String, Array<String>] :buttons string
      #   buttons to assign to dialog
      #
      def initialize(args={})
        super
        @message = [args[:message]].flatten.compact
        @buttons = [args[:buttons]].flatten.compact

        @buttons = BUTTONS[:ok_cancel] if @buttons.empty?
      end

      def selected
        strip_formatting(buttons[component.current_button])
      end

      # Client may invoke this to
      #   - create dialog and window
      #   - activate it
      #   - close / cleanup
      def self.show(args={})
        dlg = self.new args
        win = Window.new
        win.component = dlg
        dlg.activate!
        dlg.close!
        return "" unless dlg.normal_exit?
        dlg.selected
      end

      def requested_rows
        5
      end

      def requested_cols
        [message.size, total_button_size].max
      end

      def close!
        window.erase
        window.finalize!
        self
      end

      private

      def _component
        CDK::DIALOG.new(window.cdk_scr,
                        CDK::CENTER, CDK::CENTER,
                        @message, @message.size,
                        @buttons, @buttons.size,
                        Ncurses.COLOR_PAIR(2) | Ncurses::A_REVERSE, # highlight
                        true, true, false)                          # seperate, box, shadow
      end
    end # Dialog
  end # module Components
end # module RETerm
