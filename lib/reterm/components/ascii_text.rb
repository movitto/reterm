module RETerm
  module Components
    # Renders specified text via ascii graphics.
    #
    # This Component depends on the 'artii' gem.
    class AsciiText < Component

      # Initialize the AsciiText component
      #
      # @param [Hash] args ascii text params
      # @option args [String] :text actual text to render,
      #   default empty string
      # @option args [String] :font font to use
      def initialize(args={})
        @text = args[:text] || ""
        @font = args[:font]
      end

      def requested_rows
        lines.size + 1
      end

      def requested_cols
        lines.max { |l1, l2| l1.size <=> l2.size } + 1
      end

      def draw!
        refresh_win
      end

      private

      def atext
        @atext ||= begin
          require 'artii'
          art = @font.nil? ? Artii::Base.new :
                             Artii::Base.new(:font => @font)
          art.asciify @text
        end
      end

      def lines
        @lines ||= atext.split("\n")
      end

      def refresh_win
        y = 1
        lines.each { |t|
          window.mvaddstr(y, 1, t)
          y += 1
        }

        window.refresh
        update_reterm
      end
    end # class AsciiText
  end # module Components
end # module RETerm
