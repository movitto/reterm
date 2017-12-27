module RETerm
  module ButtonHelpers
    def total_button_size
      @buttons.sum { |b| b.size }
    end
  end # module ButtonHelpers
end # module RETerm
