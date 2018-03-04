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
        super
        @title = args[:title] || ""
      end

      attr_reader :title

      def title=(t)
        @title = t
        component.setMessage(t)
      end

      def skip_formatting=(b)
        component.skip_formatting = b
      end

      def requested_rows
        2
      end

      def requested_cols
        @title.size + 1
      end

      def activate!
        dispatch :clicked
        deactivate!
      end

      def click!
        activate!
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
