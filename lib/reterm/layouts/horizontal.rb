module RETerm
  module Layouts
    # Layout which arrainges items horizontally across screen cols
    class Horizontal < Layout
      def current_cols
        children.sum { |c| c.cols } + 1
      end

      def exceeds_bounds?(child)
        child.rows > window.rows || (current_cols + child.cols) > window.cols
      end

      def add_child(h={})
        # set x/y to next appropriate location
        super(h.merge(:y => 1, :x => current_cols))
      end
    end # class Horizontal
  end # module Layouts
end # module RETerm
