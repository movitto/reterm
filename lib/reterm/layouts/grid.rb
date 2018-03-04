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

        x1 < window.x    || y1 < window.y ||
        x2 > window.cols || y2 > window.rows
      end

      def valid_input?(ch, from_parent)
        if     UP_CONTROLS.include?(ch)
          return focusable.any? { |f| f.window.y < focused.window.y }

        elsif  DOWN_CONTROLS.include?(ch)
          return focusable.any? { |f| f.window.y > focused.window.y }

        elsif  LEFT_CONTROLS.include?(ch)
          focusable.any? { |f| f.window.x < focused.window.x }

        elsif RIGHT_CONTROLS.include?(ch)
          focusable.any? { |f| f.window.x > focused.window.x }
        end
      end

      # Cycle through components child position on grid
      def next_focus(ch)
        f = nil
        if     UP_CONTROLS.include?(ch)
          f = focusable.select { |f| f.window.y < focused.window.y }.first

        elsif  DOWN_CONTROLS.include?(ch)
          f = focusable.select { |f| f.window.y > focused.window.y }.first

        elsif  LEFT_CONTROLS.include?(ch)
          f = focusable.select { |f| f.window.x < focused.window.x }.first

        elsif RIGHT_CONTROLS.include?(ch)
          f = focusable.select { |f| f.window.x > focused.window.x }.first

        else
          return super
        end

        focusable.index(f)
      end
    end # class Grid
  end # module Layouts
end # module RETerm
