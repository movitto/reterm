require 'reterm'
include RETerm

CMD = File.join(File.expand_path(File.dirname(__FILE__)), 'cmd.rb')

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 120
  win.border!
  update_reterm

  yt = Components::YouTube.new :url => ""
  win.component = yt
  # ...
}
