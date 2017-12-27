module RETerm
  module Layouts
    # Layout which arrainges items horizontally across screen cols
    class Horizontal < Layout
      def current_rows
        return 1 if empty?
        child_windows.max { |w1, w2| w1.rows <=> w2.rows }.rows
      end

      def current_cols
        return 1 if empty?
        child_windows.sum { |c| c.cols } + 1
      end

      def exceeds_bounds_with?(child)
        rows = child.is_a?(Hash) ?
               [current_rows, child[:rows]].compact.max :
               [current_rows, child.rows].max

        cols = child.is_a?(Hash) ?
          current_cols + child[:cols] :
          current_cols + child.cols

        rows >= window.rows ||
        cols >= window.cols
      end

      def add_child(h={})
        # set x/y to next appropriate location
        super(h.merge(:y => 1, :x => current_cols))
      end
    end # class Horizontal
  end # module Layouts
end # module RETerm
