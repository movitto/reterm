module RETerm
  module Components
    # YouTube viewer, use cmds to render youtube to ascii:
    #   youtube-dl <url>
    #   mplayer -vo aa <file>    -or-
    #   CACA_DRIVER=ncurses mplayer -vo caca <file>
    class YouTube < CmdOutput
      # Initialize the YouTube component
      #
      # @param [Hash] args youtube params
      # @option args [String] :url url of the video
      #   to load
      def initialize(args={})
        @url = args[:url]
        cmd = "..."
        super(args.merge(:cmd => cmd))
      end
    end # YouTube
  end # module Components
end # module RETerm
