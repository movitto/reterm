module RETerm
  module ItemHelpers
    def max_item_size
      return 0 if @items.empty?
      @items.max { |i1, i2| i1.size <=> i2.size }.size
    end
  end # module ItemHelpers
end # module RETerm
