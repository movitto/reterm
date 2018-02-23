module RETerm
  # Helper returning boolean indicating if specified process is alive
  def process_alive?(pid)
    begin
      Process.getpgid( pid )
      true
    rescue Errno::ESRCH
      false
    end
  end

  ANSI_COLORS = {
         1 => :bold,
        30 => :black,
        31 => :red,
        32 => :green,
        33 => :yellow,
        34 => :blue,
        35 => :magenta,
        36 => :cyan,
        37 => :white,

        # XXX techincally the 'bright' variations
        90 => :black,
        91 => :red,
        92 => :green,
        93 => :yellow,
        94 => :blue,
        95 => :magenta,
        96 => :cyan,
        97 => :white,
  }

  # Converts specified ansi string to array
  # of character data & corresponding control
  # logic
  def parse_ansi(str)
    require 'strscan'

    r = []
    f = []
    t = []

    a = nil
    s = StringScanner.new(str)

    while(!s.eos?)
      # end of formatting
      if s.scan(/(\e|\[)\[0m/)
        t << f.pop
        t.compact!
        if f.empty?
          r << [a, t]
          t = []
          a = nil
        end

      # basic formatter
      elsif s.scan(/\e\[(3[0-7]|90|1)m/)
        # FIXME need to register formatting for 'a'
        # up to this point (and reset 'a') (and below)
        f << ANSI_COLORS[s[1].to_i]

      # sgr
      # https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
      elsif s.scan(/\e\[(([0-9]+;?)+)m/)
        sgr = s[1].split(";").collect { |s| s.to_i }
        f << if (30..37).include?(sgr[0])
               ANSI_COLORS[sgr[1]]

             elsif sgr[0] == 38
               if sgr[1] == 5
                if sgr[2] < 8
                  ANSI_COLORS[sgr[2]]

                elsif sgr[2] < 16
                  ANSI_COLORS[sgr[2]]

                elsif sgr[2] < 232
                  # TODO verify:
                  # https://stackoverflow.com/questions/12338015/converting-8-bit-color-into-rgb-value
                  re = (sgr[2] >> 5) * 32
                  gr = ((sgr[2] & 28) >> 2) * 32
                  bl = (sgr[2] & 3) * 64
                  [re, gr, bl]

                else # if srg[2] < 256
                  # TODO
                end

               else # if sgr[1] == 2
                 # TODO
               end

               # TODO other sgr commands
             end

      else
        a  = "" if a.nil?
        a += s.scan(/./m)

      end
    end


    # handle remaining / lingering data
    r << [a, (t + f).compact] unless f.empty?

    r
  end

  # Helper appending string to debug file
  def file_append(f, t)
    File.open(f, "a") { |f| f.write t }
  end

  # Flushes all input queues
  def flush_input
    Ncurses.flushinp
  end
end # module RETerm
