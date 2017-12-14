module RETerm
  module Components
    # Rocker component, allowing use to select one of several values
    class Rocker < Component
      include ComponentInput

      attr_accessor :values, :index, :labels

      # Initialize the Rocker component
      #
      # @param [Hash] args rocker params
      #
      # @example using the Rocker
      #   win    = Window.new
      #   rocker = Rocker.new
      #   win.component = rocker
      #   rocker.values = ['Foo', 'Bar', 'Baz']
      #   val = rocker.activate!
      #
      def initialize(args={})
        @values = []
        @index  = nil
        @labels = true
        @index  = 0
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
        @values[@index]
      end

      private

      def on_inc
        @index += 1
        @index  = @values.size - 1 if @index == @values.size
        refresh_win
      end

      def on_dec
        @index -= 1
        @index  = 0 if @index < 0
        refresh_win
      end

      def refresh_win
        pre  = post = ' '
        pre  = '-' if @labels
        post = '+' if @labels

        window.mvaddstr(1, 1, " |#{pre}|")
        @values.each_with_index { |v, i|
          sel = @index == i ? "#" : " "
          window.mvaddstr(i+2, 1, " |" + sel + "|" + @values[i])
        }
        window.mvaddstr(@values.size+2, 1, " |#{post}|")
        window.refresh
        update_reterm
      end
    end # Rocker
  end # module Components
end # module RETerm
