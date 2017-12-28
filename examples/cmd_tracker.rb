require 'reterm'
include RETerm

CMD = File.join(File.expand_path(File.dirname(__FILE__)), 'components', 'cmd.rb')

init_reterm {
  win = Window.new
  update_reterm

  cmd = Components::CmdOutput.new :cmd => "ruby #{CMD}"

  bb = Components::ButtonBox.new :title  => "Exit Anytime",
                                 :widget => cmd
  win.component = bb

  cmd.start!
  bb.activate!

  # wait for wrapup if we want:
  #cmd.wait
}
