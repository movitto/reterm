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

  label = Components::Label.new :text => "Welcome to the UI!"
  layout1.add_child :component => label

  ###

  layout2 = Layouts::Horizontal.new
  layout1.add_child :component => layout2

  dial = Components::Dial.new
  layout2.add_child :component => dial

  entry = Components::Entry.new :title => "Enter: ", :label => "Text:"
  layout2.add_child :component => entry

  ###

  layout3 = Layouts::Horizontal.new
  layout1.add_child :component => layout3

  slider = Components::HSlider.new :title => "Value: "
  layout3.add_child :component => slider

  ###

  win.activate!

  results[:dial]   = dial.value
  results[:entry]  = entry.value
  results[:slider] = slider.value
}

puts "Input results: "
puts results
