module RETerm
  module Components
    # CDK Entry Component
    class Entry < Component
      include CDKComponent

      # Initialize the Entry component
      #
      # @param [Hash] args entry params
      # @option args [String] :title title to assign
      #   to entry
      # @option args [String] :label label to assign
      #   to entry
      # @option args [Integer] :min min entry length
      # @option args [Integer] :max max entry length
      def initialize(args={})
        @title   = args[:title] || ""
        @label   = args[:label] || ""
        @min_len = args[:min]   || 0
        @max_len = args[:max]   || 100
      end

      private

      def _component
        CDK::ENTRY.new(window.cdk_scr,            # cdkscreen,
                       CDK::CENTER, CDK::CENTER,  # xpos, ypos
                       @title, @label,            # title, label
                       Ncurses::A_NORMAL,         # field attribute (eg typed chars)
                       '.',                       # filler char
                       :MIXED,                    # display type
                       window.cols-@label.size-5, # field width
                       0, 256,                    # min/max len
                       false, false)              # box, shadow
      end
    end # Entry
  end # module Components
end # module RETerm
