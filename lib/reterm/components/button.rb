module RETerm
  module Components
    # CDK Button Component
    class Button < Component
      include CDKComponent

      # Initialize the Button component
      #
      # @param [Hash] args button params
      # @option args [String] :title title of button
      def initialize(args={})
        @title = args[:title] || ""
      end

      def requested_rows
        3
      end

      def requested_cols
        @title.size
      end

      private

      def callback
        proc { |b|
          dispatch :clicked
        }
      end

      def _component
        CDK::BUTTON.new(window.cdk_scr,           # cdk screen
                        CDK::CENTER, CDK::CENTER, # x, y
                        @title,                   # title
                        callback,                 # click callback
                        false, false)             # box, shadow
      end
    end # Button
  end # module Components
end # module RETerm
