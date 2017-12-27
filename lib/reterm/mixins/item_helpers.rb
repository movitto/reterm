module RETerm
  module ItemHelpers
    def max_item_size
      @items.max { |i1, i2| i1.size <=> i2.size }
    end
  end # module ItemHelpers
end # module RETerm
