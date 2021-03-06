require 'date'

module RETerm
  module Components
    # Text that is revealed incrementally over time
    class RevealingLabel < Component

      attr_accessor :text

      # Initialize the RevealingLabel component
      #
      # @param [Hash] args revealing label params
      # @option args [String] :text text of the label
      def initialize(args={})
        activate_sync!

        super
        self.text      = args[:text] || ""

        # time between characters being revealed
        @char_time = args[:char_time] || 0.01

        # time wait after a line is displayed before starting new
        @line_wait = args[:line_wait] || 3

        @draw_next = false
        @timestamp = nil
      end

      def text=(t)
        @text  = t
        @lines = nil
        @current_line = nil
        @current_index = nil
      end

      def empty?
        @text.nil? || @text.length == 0
      end

      def lines
        @lines ||= text.split("\n")
      end

      def requested_rows
        lines.size + 1
      end

      def requested_cols
        empty? ? 1 :
        lines.max { |l1, l2| l1.size <=> l2.size }.size + 1
      end

      def sync!
        if @timestamp.nil?
          @draw_next = true

        else
          if @current_index == 0
            if (DateTime.now - @timestamp) * 24 * 60 * 60 > @line_wait
              @draw_next = true
            end

          else
            if (DateTime.now - @timestamp) * 24 * 60 * 60 > @char_time
              @draw_next = true
            end
          end
        end

        draw!
      end

      def reset!
        @current_line  = 0
        @current_index = 0
      end

      def draw!
        @current_line  ||= 0
        @current_index ||= 0

        return unless @draw_next
        @draw_next = false

        current = ((lines.size > @current_line) &&
                   (lines[@current_line].size > @current_index)) ?
                    lines[@current_line][@current_index] :
                    ""

        dispatch :start_reveal if @current_line  == 0 &&
                                  @current_index == 0

        @timestamp = DateTime.now
        window.mvaddstr(@current_line  + 1,
                        @current_index + 1,
                        current)

        dispatch :revealed_char, current

        set_next
      end

      def set_next
        return if empty?
        @current_index += 1

        if @current_index >= lines[@current_line].size
          @current_index = 0
          @current_line += 1
        end

        if @current_line >= lines.size
          @current_line = 0
          dispatch :revealed
        end
      end

      def erase
        lines.each_with_index { |l, i|
          window.mvaddstr(i+1, 1, " " * l.size)
        }
      end
    end # RevealingLabel
  end # module Components
end # module RETerm
