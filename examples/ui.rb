require 'reterm'
include RETerm

results = {}

init_reterm {
  ColorPair.change :green, 0, 700, 0
  ColorPair.register :green, :black, :main

  win = Window.new
  win.colors = :main
  win.border!

  layout1 = Layouts::Vertical.new
  win.component = layout1

  child1 = layout1.add_child :rows => 3,
                             :cols => 20

  label = Components::Label.new :text => "Welcome to the UI!"
  child1.component = label

  ###

  child2 = layout1.add_child :rows => 20,
                             :cols => 65

  layout2 = Layouts::Horizontal.new
  child2.component = layout2

  child3 = layout2.add_child :rows => 10,
                             :cols => 10

  dial = Components::Dial.new
  child3.component = dial

  child4 = layout2.add_child :rows => 15,
                             :cols => 40

  entry = Components::Entry.new :title => "Enter: ", :label => "Text:"
  child4.component = entry

  ###

  child5 = layout1.add_child :rows => 15,
                             :cols => 65

  layout3 = Layouts::Horizontal.new
  child5.component = layout3

  child6 = layout3.add_child :rows => 10,
                             :cols => 50

  slider = Components::HSlider.new :title => "Value: "
  child6.component = slider

  ###

  win.activate!

  results[:dial]   = dial.value
  results[:entry]  = entry.value
  results[:slider] = slider.value
}

puts "Input results: "
puts results
