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
        x1 = child.is_a?(Hash) ? child[:x] : child.x
        y1 = child.is_a?(Hash) ? child[:y] : child.y

        x2 = child.is_a?(Hash) ?
              [current_cols, x1 + child[:cols]].compact.max :
              [current_cols, x1 + child.cols].max

        y2 = child.is_a?(Hash) ?
               [current_rows, y1 + child[:rows]].compact.max :
               [current_rows, y1 + child.rows].max

        x1 <= window.x    || y1 <= window.y ||
        x2 >= window.cols || y2 >= window.rows
      end

     # TODO: Override handle_movement, cycle through components
     # based on movement direction & child position on grid
    end # class Grid
  end # module Layouts
end # module RETerm
