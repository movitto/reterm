module RETerm
  module Layouts
    # Layout which permits the user to arrainge items anywhere on screen
    class Grid < Layout
      def current_rows
        return 1 if empty?
        child_windows.max { |c1, c2| c1.rows <=> c2.rows }.rows + 1
      end

      def current_cols
        return 1 if empty?
        child_windows.max { |c1, c2| c1.cols <=> c2.cols }.cols + 1
      end

      def exceeds_bounds_with?(child)
        cols = child.is_a?(Hash) ?
               [current_cols, child[:cols]].compact.max :
               [current_cols, child.cols].max

        rows = child.is_a?(Hash) ?
               [current_rows, child[:rows]].compact.max :
               [current_rows, child.rows].max

        x = child.is_a?(Hash) ? child[:x] : child.x
        y = child.is_a?(Hash) ? child[:y] : child.y

        x <= window.x || y <= window.y ||
        (x + cols) >= window.cols      ||
        (y + rows) >= window.rows
      end

      def add_child(h={})
        raise ArgumentError, "must specify x/y" unless h.key?(:x) &&
                                                       h.key?(:y)
        super
      end
    end # class Grid
  end # module Layouts
end # module RETerm
