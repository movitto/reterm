module RETerm
  module Components
    # CDK Entry Component
    class Entry < Component
      include CDKComponent

      attr_accessor :title

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
        super
        @title    = args[:title] || ""
        @label    = args[:label] || ""
        @min_len  = args[:min]   || 0
        @max_len  = args[:max]   || 100
        @min_size = args[:size]  || 0
      end

      def requested_rows
        5
      end

      def requested_cols
        [@title.size, @label.size, @min_size].max + 3
      end

      def value
        component.getValue
      end

      private

      def disp_type
        :MIXED
      end

      def _component
        c = CDK::ENTRY.new(window.cdk_scr,            # cdkscreen,
                           CDK::CENTER, CDK::CENTER,  # xpos, ypos
                           @title, @label,            # title, label
                           Ncurses::A_NORMAL,         # field attribute (eg typed chars)
                           '.'.ord,                   # filler char
                           disp_type,                 # display type
                           window.cols-@label.size-5, # field width
                           0, 512,                    # min/max len
                           false, false)              # box, shadow
        e = self
        callback = lambda do |cdktype, entry, component, key|
          component.dispatch :entry, key
        end

        c.setPostProcess(callback, self)

        c
      end
    end # Entry
  end # module Components
end # module RETerm
