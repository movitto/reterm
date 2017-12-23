require 'pty'
module RETerm
  module Components
    # Run command, capture and display output
    class CmdOutput < ScrollingArea
      # Initialize the CmdOutput component
      #
      # @param [Hash] args cmd output params
      # @option args [String] :cmd command to run
      def initialize(args={})
        super
        @cmd = args[:cmd]
      end

      def running?
        !!PTY.check(@pid)
      end

      def resync
        out = nil
        begin
          out = @stdout.gets
        rescue Errno::EIO
        end
        self << out if out
      end

      def finalize!
        if running?
          Process.kill @pid
          @stdout.close
          @stdout.close
        end
      end

      def start!
        @stdout, @stdin, @pid = PTY.spawn(@cmd)
        nil
      end
    end # CmdOutput
  end # module Components
end # module RETerm
