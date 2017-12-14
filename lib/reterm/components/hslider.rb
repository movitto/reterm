module RETerm
  module Components
    # Horizontal Slider, implemented using Slider CDK component
    class HSlider < Component
      include CDKComponent

      # Initialize the HSlider component
      #
      # @param [Hash] args slider params
      # @option args [String] :title title of slider
      # @option args [String] :label label of slider
      def initialize(args={})
        @title = args[:title] || " "
        @label = args[:label] || " "

        @increment     = 1
        @range         = [0, 100]
      end

      private

      def _component
        CDK::SLIDER.new(window.cdk_scr,                       # cdkscreen,
                        CDK::CENTER, CDK::CENTER,             # xplace, yplace
                        @title, @label, '#'.ord,              # title, label, filler,
                        window.cols-6, @range[0], @range[0],  # field_width, start, low,
                        @range[1], @increment, @increment*2,  # high, inc, fast_inc,
                        false, false)                         # box, shadow
      end
    end # VSlider
  end # module Components
end # module RETerm
