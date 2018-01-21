module RETerm
  module Components
    # Vertical Slider Component
    class VSlider < Component
      include ComponentInput

      attr_accessor :initial_value, :increment, :range, :labels

      # Initialize the slider component
      #
      # @param [Hash] args slider params
      def initialize(args={})
        super
        @initial_value = 0
        @increment     = 0.01
        @range         = [0, 1]
        @labels        = true
        @value = initial_value
      end

      def requested_rows
        10
      end

      def requested_cols
        3
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
        (range[1] - range[0]) * @value
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
        0.upto(window.rows) do |l|
          pre  = " "
          pre  = "+" if @labels && l == 0
          pre  = "-" if @labels && l == (window.rows-1)
          fill = (l.to_f / window.rows) >= (1-@value)
          window.mvaddstr(l, 0, pre + (fill ? "#" : " ") + "\n")
        end

        window.refresh
      end
    end # VSlider
  end # module Components
end # module RETerm
