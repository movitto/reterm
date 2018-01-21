module RETerm
  module Components
    # Renders and image to the screen using drawille and chunkpng.
    class Image < Component

      # Initialize the Image component
      #
      # @param [Hash] args image params
      # @option args [String] :file path to the file containing
      #   the image
      def initialize(args={})
        super
        @file = args[:file]
      end

      def draw!
        refresh_win
      end

      def requeseted_rows
        image.dimension.height
      end

      def requested_cols
        image.dimension.width
      end

      protected

      def canvas
        require 'drawille'
        @canvas ||= Drawille::Canvas.new
      end

      def image
        require 'chunky_png'
        @image ||= ChunkyPNG::Image.from_file(@file)
      end

      def refresh_win
        w = [image.dimension.width-1,  window.cols].min
        h = [image.dimension.height-1, window.rows].min

        (0..w).each do |x|
          (0..h).each do |y|
            r = ChunkyPNG::Color.r(image[x,y])
            g = ChunkyPNG::Color.g(image[x,y])
            b = ChunkyPNG::Color.b(image[x,y])
            canvas.set(x, y) if (r + b + g) > 100
          end
        end

        y = 1
        canvas.frame.split("\n").each { |line|
          window.mvaddstr(y, 1, line)
          y += 1
        }

        window.refresh
        update_reterm
      end
    end # class Canvas
  end # module Components
end # module RETerm
