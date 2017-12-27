require 'reterm'
include RETerm

r = nil
e = nil
init_reterm {
  win1 = Window.new :rows => 20,
                    :cols => 50
  win1.border!

  win2 = Window.new :rows => 5,
                    :cols => 20,
                    :x    => 10,
                    :y    => 10
  win2.border!

  menu = Components::DropDownMenu.new :menus => [{"File"  =>  nil,
                                                  "New"   => :new,
                                                  "Quit"  => :quit},
                                                 {"Help"  =>  nil,
                                                  "About" => :about}]

  label = Components::Label.new :text => ""
  win2.component = label

  menu.handle(:changed) {
    label.text = "Changed to #{menu.current}"
    label.draw!
  }

  win1.component = menu
  r = menu.activate!
  e =  menu.normal_exit? ? :normal :
      (menu.early_exit?  ? :early :
      (menu.escape_hit? ? :esc : ""))
}

puts "Menu choice #{r} (#{e})"
