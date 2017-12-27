module RETerm
  module Components
    # CDK MultiLineEntry Component
    class MultiLineEntry < Component
      include CDKComponent

      # Initialize the MultiLineEntry component
      #
      # @param [Hash] args entry params
      # @option args [String] :title title to assign
      #   to entry
      # @option args [String] :label label to assign
      #   to entry
      # @option args [Integer] :min min entry length
      # @option args [Integer] :rows number of logical rows
      #   to create
      def initialize(args={})
        @title   = args[:title] || ""
        @label   = args[:label] || ""
        @min_len = args[:min]   || 0
        @rows    = args[:rows]  || nil
      end

      def requested_rows
        3 + @rows
      end

      def requested_cols
        [@title.size, @label.size + 5].min
      end

      private

      def _component
        width  = window.cols - @label.size - 5
        height = window.rows - 5
        rows   = @rows || height

        CDK::MENTRY.new(window.cdk_scr,            # cdkscreen,
                        CDK::CENTER, CDK::CENTER,  # xpos, ypos
                        @title, @label,            # title, label
                        Ncurses::A_BOLD,           # field attribute (eg typed chars)
                        '.',                       # filler char
                        :MIXED,                    # display type
                        width,                     # field width
                        height,                    # field height (rows)
                        rows,                      # logical rows
                        @min_len,                  # min length
                        false, false)              # box, shadow
      end
    end # MultiLineEntry
  end # module Components
end # module RETerm
