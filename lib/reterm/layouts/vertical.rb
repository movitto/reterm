module RETerm
  module Layouts
    # Layout which arrainges items vertically down screen rows
    class Vertical < Layout
      def current_rows
        child_windows.sum { |c| c.rows } + 1
      end

      def exceeds_bounds?
        child_windows.any? { |child| child.cols > window.cols } ||
        current_rows > window.rows
      end

      def add_child(h={})
        # set x/y to next appropriate location
        super(h.merge(:y => current_rows, :x => 1))
      end
    end # class Horizontal
  end # module Layouts
end # module RETerm
