require 'reterm'
include RETerm

conf = File.join(File.expand_path(File.dirname(__FILE__)), 'win.json')

init_reterm {
  load_reterm(File.read(conf)).activate!
}
