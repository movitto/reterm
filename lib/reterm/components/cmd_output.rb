require 'timeout'
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
        activate_sync!

        super
        @cmd = args[:cmd]
      end

      def running?
        !!@pid && process_alive?(@pid)
      end

      def sync!
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
        self
      end

      def wait
        while running?
          begin
            Timeout.timeout(SYNC_TIMEOUT.to_f/1000) do
              begin
                Process.waitpid @pid
              rescue
                # rescue needed incase process exit between
                # running? check and waitpid
              end
            end
          rescue Timeout::Error
            run_sync!
          end
        end

        # NOTE: at this point process will be closed but
        # there may still be unread data in stdout/stderr
        # buffers!!!

        self
      end
    end # CmdOutput
  end # module Components
end # module RETerm
