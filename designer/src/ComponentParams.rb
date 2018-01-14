# Popup window allowing us to set component parameters
class ComponentParams
  include GladeGUI

  def initialize(component, window)
    super()
    @component = component
    @window = window
  end

  def submit_button__clicked(*args)
    @window.create_component(@component, component_params)
    @builder["window1"].destroy
  end

  def cancel_button__clicked(*args)
    @builder["window1"].destroy
  end

  def before_show
    set_title
    add_component_params
    add_general_params
  end

  private

  def set_title
    @builder[:component_edit_title].text = "Edit \"#{@component}\" params"
  end

  def add_component_params
    COMPONENTS[@component][:params].each { |label, type|
      add_params(label, type)
    }
  end

  def add_general_params
    COMPONENTS[:generic][:params].each { |label, type|
      add_params(label, type)
    }

    # TODO if adding to Grid Layout also add x/y params
    # (required, default to 1)
  end

  def add_params(label, type)
    layout = Gtk::HBox.new

    glabel = Gtk::Label.new label
    glabel.margin = 5
    layout.add glabel
    glabel.show

    if type.is_a?(Array)
      placeholder = Gtk::Image.new(:file => "#{IMG_DIR}/blank_sm.png")
      layout.pack_end placeholder
      placeholder.margin = 14
      placeholder.show

      add_img = Gtk::Image.new(:file => "#{IMG_DIR}/add.png")
      add_btn = Gtk::Button.new
      add_btn.margin = 5
      add_btn.add(add_img)

      layout.pack_end add_btn
      add_btn.signal_connect("clicked") {
        add_row(type)
      }

      add_img.show
      add_btn.show
    end

    if type == :bool
      gchk = Gtk::CheckButton.new
      layout.pack_end gchk
      gchk.show

    else
      gedit = Gtk::Entry.new
      layout.pack_end gedit
      gedit.show
    end


    @builder[:component_edit_layout].add layout
    layout.show
  end

  def component_params
    @builder[:component_edit_layout].children.collect { |c|
      p = c.children.first # label
           .text


      t = (COMPONENTS.key?(@component) &&
           COMPONENTS[@component].key?(:params) &&
           COMPONENTS[@component][:params].key?(p)) ?
           COMPONENTS[@component][:params][p] :
           COMPONENTS[:generic][:params][p]

      t = t.first if t.is_a?(Array)

      if t == :bool
        !!c.children[1].active?

      else
        txt = c.children[1].text

        if t == :int
          txt.to_i
        else # if t == :string
          txt
        end
      end
    }
  end

  def add_row(type)
    layout = Gtk::HBox.new
    glabel = Gtk::Label.new
    glabel.margin = 5
    layout.add glabel
    glabel.show

    rm_img = Gtk::Image.new(:file => "#{IMG_DIR}/remove.png")
    rm_btn = Gtk::Button.new
    rm_btn.add(rm_img)
    rm_btn.margin = 5
    layout.pack_end rm_btn
    rm_btn.signal_connect("clicked") {
      rm_row(layout)
    }
    rm_img.show
    rm_btn.show

    add_img = Gtk::Image.new(:file => "#{IMG_DIR}/add.png")
    add_btn = Gtk::Button.new
    add_btn.margin = 5
    add_btn.add(add_img)
    layout.pack_end add_btn
    add_btn.signal_connect("clicked") {
      add_row(type)
    }
    add_img.show
    add_btn.show

    if type == :bool
      gchk = Gtk::CheckButton.new
      layout.pack_end gchk
      gchk.show

    else
      gedit = Gtk::Entry.new
      layout.pack_end gedit
      gedit.show
    end

    @builder[:component_edit_layout].add layout
    layout.show
  end

  def rm_row(layout)
    @builder[:component_edit_layout].remove layout
  end
end
