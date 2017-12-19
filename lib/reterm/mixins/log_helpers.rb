module RETerm
  # Helpers defin
  module LogHelpers
    LOG_FILE = './reterm.log'

    def logger
      require 'logger'
      @@logger ||=  Logger.new LOG_FILE
    end

    alias :log :logger
  end # module LogHelpers
end # module RETerm
