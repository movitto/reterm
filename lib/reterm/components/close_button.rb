module RETerm
  module Components
    class CloseButton < Button
      def initialize(args={})
        super({:title => "X"}.merge(args))
      end

      def activate_focus?
        true
      end

      private

      def callback
        proc { |b|
          dispatch :clicked
          shutdown!
        }
      end
    end # CloseButton
  end # module Components
end # module RETerm
