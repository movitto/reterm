# Mechanism which user specifies area to add component
class ToggleArea
  attr_accessor :toggled

  def toggle_on
    @toggled = true
    btn.remove(add)
    btn.add(rm)
    @designer.toggle_area = self
  end

  def toggle_off
    @toggled = false
    btn.remove(rm)
    btn.add(add)
    show
    @designer.clear_toggle_area
  end

  def add
    @add ||= Gtk::Image.new :file => "#{IMG_DIR}/add.png"
  end

  def rm
    @rm ||= Gtk::Image.new :file => "#{IMG_DIR}/remove.png"
  end


  def btn
    @btn ||=
      begin
        b = Gtk::Button.new
        b.add add

        b.signal_connect("clicked") { |*args|
          if @toggled
            toggle_off
          else
            toggle_on
          end

          show
        }

        css_provider = Gtk::CssProvider.new
        css_provider.load(data: "button:hover {background-image: image(#FFFF00);}")
        b.style_context.add_provider(css_provider, Gtk::StyleProvider::PRIORITY_USER)

        b
      end
  end

  def show
    btn.show

    if @toggled
      rm.show
    else
      add.show
    end
  end

  def initialize(designer)
    @designer = designer
    @toggled = false
  end
end
