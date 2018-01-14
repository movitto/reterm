require 'json'

module RETerm
  class Config
    CONFIG_FILE = File.expand_path("~/.reterm")

    def self.get
      @config ||=
        begin
          return {} unless File.exist?(CONFIG_FILE)
          JSON.parse(File.read(CONFIG_FILE))
        end
    end

    def self.load_plugins
      return unless get.key?("plugins")
      get["plugins"].each { |p|
        require p
      }
    end
  end # class Config
end # module RETerm
