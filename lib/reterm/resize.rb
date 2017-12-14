module RETerm
  # Seconds between terminal size syncs
  RESIZE_TIME = 0.2

  # Internal helper to track size of terminal.
  # This is a simple mechanism that launches a
  # worker thread to periodically poll terminal size.
  def track_resize
    @track_resize = true
    d = Terminal.dimensions

    @resize_thread = Thread.new {
      while @track_resize
        Terminal.reset!
        t = Terminal.dimensions
        Terminal.resize! if t != d
        sleep(RESIZE_TIME)
      end
    }
  end

  # Terminate resize tracking thread (if running)
  def stop_track_resize
    @track_resize = false
    @resize_thread.join if @resize_thread
  end
end # module RETerm
