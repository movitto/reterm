module RETerm
  module Layouts
    # Layout which arainges items vertically down screen rows
    class Vertical < Layout
      def current_rows
        return 1 if empty?
        child_windows.sum { |c| c.rows } + 1
      end

      def current_cols
        return 1 if empty?
        child_windows.max { |w1, w2| w1.cols <=> w2.cols }.cols
      end

      def exceeds_bounds_with?(child)
        cols = child.is_a?(Hash) ?
               [current_cols, child[:cols]].compact.max :
               [current_cols, child.cols].max

        rows = child.is_a?(Hash) ?
          current_rows + child[:rows] :
          current_rows + child.rows

        cols > window.cols ||
        rows > window.rows
      end

      def add_child(h={})
        # set x/y to next appropriate location
        super(h.merge(:y => current_rows, :x => 1))
      end

      def valid_input?(ch, from_parent)
        return true unless from_parent
        !((LEFT_CONTROLS.include?(ch) && window.first_child?) ||
         (RIGHT_CONTROLS.include?(ch) && window.last_child?))
      end
    end # class Vertical
  end # module Layouts
end # module RETerm
