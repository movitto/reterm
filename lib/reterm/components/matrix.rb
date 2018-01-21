module RETerm
  module Components
    # CDK Matrix Component
    class Matrix < Component
      include CDKComponent

      # Initialize the Matrix component
      #
      # @param [Hash] args matrix params
      def initialize(args={})
        super
        @rows  = args[:rows]
        @cols  = args[:cols]
        @title = args[:title]

        @rowtitles = args[:rowtitles] || args[:row_titles] || Array.new(@rows) { "" }
        @coltitles = args[:coltitles] || args[:col_titles] || Array.new(@cols+1) { "" }
        @colwidths = args[:colwidths] || args[:col_widths] || Array.new(@cols+1) { 5 }
        @coltypes  = args[:coltypes]  || args[:col_types]  || Array.new(@cols+1) { :UMIXED }
      end

      def get(x, y)
        component.getCell(x, y)
      end

      def requeseted_rows
        4 + 2 * rows + 1
      end

      def requested_cols
        2 + 2 * rows + 1
      end

      private

      def _component
        CDK::MATRIX.new(window.cdk_scr,
                        2, 2,                                # xpos, ypos
                        @rows, @cols,                        # matrix rows, cols
                        [(window.rows - 2), @rows].min,      # screen rows
                        [(window.cols - 2), @cols].min,      # screen cols
                        @title,                              # title
                        @rowtitles, @coltitles,              # row/col titles
                        @colwidths, @coltypes,               # col widths and types
                        -1, -1,                              # row/col spacing
                        '.',                                 # filler
                        2,                                   # dominant attribute
                        true, true, false)                   # box matrix, box cell, shadow
      end
    end # Matrix
  end # module Components
end # module RETerm
