require 'reterm'
include RETerm

CMD = File.join(File.expand_path(File.dirname(__FILE__)), 'cmd.rb')

init_reterm {
  win = Window.new :rows => 10,
                   :cols => 120
  win.border!
  update_reterm

  cmd = Components::CmdOutput.new :cmd => "ruby #{CMD}"
  win.component = cmd

  cmd.start!.wait
}
