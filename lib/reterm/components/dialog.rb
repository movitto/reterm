module RETerm
  module Components
    # CDK Dialog Component
    class Dialog < Component
      include CDKComponent

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

        @buttons = ["</B/24>OK", "</B16>Cancel"] if @buttons.empty?
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
