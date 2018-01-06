require 'csv'

NUM_LOCS = 10

# parse location file
# sample-worldcities-basic from https://simplemaps.com/data/world-cities
CITIES_FILE = File.join(File.expand_path(File.dirname(__FILE__)),
                           './simplemaps-worldcities-basic.csv')

csv = CSV.read(CITIES_FILE, :headers => true)

###

require 'reterm'
include RETerm

require_relative './globe'
require_relative './weather_info'

init_reterm {
  win     = Window.new
  layout1 = Layouts::Grid.new
  win.component = layout1

  ###

  menus = [{"File"  => nil,
            "Quit"  => :quit},
           {"Help"  => nil,
            "About" => :about}]

  mbg  = ColorPair.register(:white, :blue)
  mc   = ColorPair.register(:black, :white)
  menu = Components::DropDown.new :menus      => menus,
                                  :color      => mc,
                                  :background => mbg
  layout1.add_child :component => menu,
                    :x => 1, :y => 1

  menu.handle(:deactivated) do
    next unless menu.normal_exit?

    if menu.selected == :about
      blue   = ColorPair.with_fg(:blue).first
      msg    = "RETerm Demo - #{blue.cdk_fmt}http://github.com/movitto/reterm"

      dwin   = Window.new
      dialog = Components::Dialog.new(:message => msg)
      dwin.component = dialog

      dialog.activate!
      dialog.close!
      update_reterm(true)

    elsif menu.selected == :quit
      shutdown!
    end
  end

  cb = Components::CloseButton.new
  layout1.add_child :component => cb,
                    :x => :right,
                    :y => :top

  ###

  layout2 = Layouts::Horizontal.new
  layout1.add_child :component => layout2,
                    :x => 1, :y => 3

  globe = Components::Globe.new
  layout2.add_child :component => globe

  locs = Components::ScrollList.new :title => "</B>Locations"
  layout2.add_child :component => locs,
                    :expand    => true,
                    :fill      => true

  locs << ""

  # Render n random locations on locs/globe
  0.upto(NUM_LOCS-1) do
    c = csv[rand(csv.size-1)]
    mark = [c["lng"].to_f, c["lat"].to_f]
    globe << mark

    color = globe.color_for(mark)
    loc = "#{color.cdk_fmt}" + c["city"].to_s + "," + c["province"].to_s
    locs << loc
  end

  locs.handle(:deactivated) do
    unless locs.normal_exit?
      locs.component.setPosition(0)
      next
    end

    loc = locs.selected.gsub(/<.*>/, '')
    weather_popup = Components::WeatherInfo.new :loc    => loc,
                                                :parent => win

    button_box = Components::ButtonBox.new :widget => weather_popup,
                                           :title  => "Weather for #{loc}"
    bbw = Window.new :rows => 0.9, :cols => 0.9,
                     :x => :center, :y => :center
    bbw.component = button_box

    button_box.activate!
    button_box.close!
    update_reterm(true)

    # reactivate locs
    # FIXME we're losing focus here
    locs.activate!
  end

  win.activate!
}
