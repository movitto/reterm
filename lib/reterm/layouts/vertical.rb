module RETerm
  module Layouts
    # Layout which arrainges items vertically down screen rows
    class Vertical < Layout
      def current_rows
        children.sum { |c| c.rows } + 1
      end

      def exceeds_bounds?(child)
        child.cols > window.cols || (current_rows + child.rows) > window.rows
      end

      def add_child(h={})
        # set x/y to next appropriate location
        super(h.merge(:y => current_rows, :x => 1))
      end
    end # class Horizontal
  end # module Layouts
end # module RETerm
