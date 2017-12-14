module RETerm
  module Components
    # Simply renders text to window
    class Label < Component

      # Initialize the Label component
      #
      # @param [Hash] args label params
      # @option args [String] :text text of button
      def initialize(args={})
        @text    = args[:text] || ""
      end

      def draw!
        window.mvaddstr(1, 1, @text)
        update_reterm
      end
    end # Label
  end # module Components
end # module RETerm
