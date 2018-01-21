module RETerm
  module Components
    # Renders specified isometric grid
    class Isometric < Component

      # Initialize the Isometric component
      #
      # @param [Hash] args isometric params
      # @option args [Array<Array<Integer,Double>>] :matrix 2-dimensional array
      #   containing Z values corresponding to x/y grid coordinates
      def initialize(args={})
        super
        @matrix = args[:matrix] || [[]]

        raise ArgumentError unless @matrix.is_a?(Array) &&
                                   @matrix.all? { |m| m.is_a?(Array) }
      end

      def requested_rows
      end

      def requested_cols
      end

      def draw!
        refresh_win
      end

      private

      def refresh_win
        # ... TODO
        window.refresh
        update_reterm
      end
    end # class Isometric
  end # module Components
end # module RETerm
