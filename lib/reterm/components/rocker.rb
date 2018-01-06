module RETerm
  module Components
    # Rocker component, allowing use to select one of several items
    class Rocker < Component
      include ComponentInput
      include ItemHelpers

      attr_accessor :items, :index, :labels

      # Initialize the Rocker component
      #
      # @param [Hash] args rocker params
      #
      # @example using the Rocker
      #   win    = Window.new
      #   rocker = Rocker.new
      #   win.component = rocker
      #   rocker.items = ['Foo', 'Bar', 'Baz']
      #   val = rocker.activate!
      #
      def initialize(args={})
        @items = []
        @index  = nil
        @labels = true
        @index  = 0
      end

      def requested_rows
        @items.size + 3
      end

      def requested_cols
        max_item_size + 3
      end

      def draw!
        refresh_win
      end

      def activatable?
        true
      end

      def activate!(*input)
        refresh_win
        handle_input(*input)
        @items[@index]
      end

      private

      def on_inc
        @index += 1
        @index  = @items.size - 1 if @index == @items.size
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
        @items.each_with_index { |v, i|
          sel = @index == i ? "#" : " "
          window.mvaddstr(i+2, 1, " |" + sel + "|" + @items[i])
        }
        window.mvaddstr(@items.size+2, 1, " |#{post}|")
        window.refresh
        update_reterm
      end
    end # Rocker
  end # module Components
end # module RETerm
