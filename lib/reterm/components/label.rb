module RETerm
  module Components
    # Simply renders text to window
    class Label < Component

      attr_accessor :text

      # Initialize the Label component
      #
      # @param [Hash] args label params
      # @option args [String] :text text of button
      def initialize(args={})
        @text    = args[:text] || ""
      end

      def draw!
        padding = " " * [0, window.cols - @text.size-2].max
        window.mvaddstr(1, 1, @text + padding)
        update_reterm
      end
    end # Label
  end # module Components
end # module RETerm
