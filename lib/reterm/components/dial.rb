module RETerm
  module Components
    class Dial < Component
      include ComponentInput

      attr_accessor :initial_value, :increment, :range, :labels

      attr_accessor :value

      # Enapsulating window should be at least 4x4 for decent effect,
      # at least 7x7 provides best resolution
      #
      # @param [Hash] args dial params
      #
      # @example activating a dial
      #   win  = Window.new
      #   dial = Dial.new
      #   win.component = dial
      #
      #   val = dial.activate!
      #
      def initialize(args={})
        @initial_value = 0
        @increment     = 0.01
        @range         = [0, 1]
        @labels        = true
        @value = initial_value
      end

      def requested_rows
        7
      end

      def requested_cols
        7
      end

      def draw!
        refresh_win
      end

      def activatable?
        true
      end

      def activate!
        refresh_win
        handle_input
        @value
      end

      private

      def on_inc
        @value += increment
        @value  = 1 if @value > 1
        refresh_win
      end

      def on_dec
          @value -= increment
          @value  = 0 if @value < 0
          refresh_win
      end

      def refresh_win
        if @labels
          window.mvaddstr(1,    1,   '-')
          window.mvaddstr(1, window.cols-2, '+')
        end

        rad = Math.sqrt((window.rows/2)**2 + (window.cols/2)**2)
        padding = rad/2 + 1

        rows = window.rows - padding
        cols  = window.cols  - padding
        rad   = Math.sqrt((rows/2)**2 + (cols/2)**2)

        a = 0
        while a < @value
          ar = a * (2 * Math::PI)
          x = rad * Math.cos(3*Math::PI/2 - ar) + cols/2  + padding/2
          y = rad * Math.sin(3*Math::PI/2 - ar) + rows/2 + padding/2
          a += increment

          window.mvaddstr(y, x, '*')
        end

        while a < 1
          ar = a * (2 * Math::PI)
          x = rad * Math.cos(3*Math::PI/2 - ar) + cols/2  + padding/2
          y = rad * Math.sin(3*Math::PI/2 - ar) + rows/2 + padding/2
          a += increment

          window.mvaddstr(y, x, ' ')
        end

        window.refresh
        update_reterm
      end
    end # class Dial
  end # module Components
end # module RETerm
