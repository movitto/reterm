module RETerm
  module Components
    # Simply renders text to window
    class Label < Component

      attr_accessor :text

      # Initialize the Label component
      #
      # @param [Hash] args label params
      # @option args [String] :text text of the label
      def initialize(args={})
        super
        @text    = args[:text] || ""
      end

      def requested_rows
        2
      end

      def requested_cols
        @text.size + 1
      end

      def draw!
        padding = " " * [0, window.cols - @text.size-2].max
        window.mvaddstr(0, 0, @text + padding)
      end

      def erase
        padding = " " * [0, window.cols - @text.size-2].max
        window.mvaddstr(0, 0, " " * (@text + padding).size)
        window.refresh
      end
    end # Label
  end # module Components
end # module RETerm
