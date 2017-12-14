# List of supported components
class ComponentsList < VR::ListView
  attr_accessor :designer

  def initialize(designer)
    @designer = designer

    @cols = {}
    @cols[:pix]   = GdkPixbuf::Pixbuf
    @cols[:title] = String
    @cols[:desc]  = String
    super(@cols)

    parse_signals # XXX needed for row activation callback

    col_title(:pix   => "",
              :title => "Component",
              :desc  => "Description")

    self.visible = true

    first = true
    selection.signal_connect("changed") {
      unless selection.selected.nil?
        changed unless first
        selection.unselect_all
        first = false
      end
    }
  end

  def add_component(c)
    row = model.append
    row[id(:pix)]   = icon_for(c)
    row[id(:title)] = c
    row[id(:desc)]  = desc_for(c)
  end

  def self__row_activated(*args)
    changed
  end

  private

  def changed
    unless designer.has_toggled_area?
      dialog = Gtk::MessageDialog.new(:parent  => designer.window,
					                            :flags   => :destroy_with_parent,
                                      :type    => :info,
                                      :buttons => :close,
                       :message => "Must select area to add component")

      dialog.signal_connect("response") { |*args|
        dialog.destroy
      }
      dialog.show
      return
    end


    c = selection.selected[1]
    e = COMPONENTS[c.intern]
    if e.key?(:params)
      w = ComponentParams.new(c.intern, designer)
      w.show_glade(designer)
    else
      designer.create_component(c.intern, [])
    end
  end

  DEFAULT_IMG = GdkPixbuf::Pixbuf.new(:file => "#{IMG_DIR}/blank.png")

  def desc_for(c)
    COMPONENTS[c][:desc]
  end

  def icon_for(c)
    if File.exist?("#{IMG_DIR}/#{c.to_s.downcase}.png")
      GdkPixbuf::Pixbuf.new(:file => "#{IMG_DIR}/#{c.to_s.downcase}.png")
    else
      DEFAULT_IMG
    end
  end

  public

  def image_for(c)
    Gtk::Image.new(icon_for(c))
  end
end
