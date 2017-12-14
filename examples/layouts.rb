require 'reterm'
include RETerm

init_reterm {
  win = Window.new :rows => 20,
                   :cols => 50

  layout = Layouts::Horizontal.new
  win.component = layout

  child1 = layout.add_child :rows => 5,
                            :cols => 10
  child1.mvaddstr(1, 1, "Child1")

  child2 = layout.add_child :rows => 5,
                            :cols => 20
  child2.mvaddstr(1, 1, "Child2")
  update_reterm
  sleep(3)

  win.clear!

  layout = Layouts::Vertical.new
  win.component = layout

  child1 = layout.add_child :rows => 5,
                            :cols => 10
  child1.mvaddstr(1, 1, "Child1")

  child2 = layout.add_child :rows => 5,
                            :cols => 20
  child2.mvaddstr(1, 1, "Child2")
  update_reterm
  sleep(3)
}
