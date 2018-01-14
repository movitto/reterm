require 'reterm'
include RETerm

require_relative './lpgrid'

init_reterm {
  win = Window.new
  lpg = Components::LPGrid.new
  win.component = lpg

  lpg.handle :down { |a|
    lpg.stop! if a[:type] == :scene8
  }

  lpg.activate!
}
