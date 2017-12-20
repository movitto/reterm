require 'reterm'

# Main designer window
class Designer
  include GladeGUI

  attr_accessor :component_list
  attr_accessor :created_list

  attr_accessor :component
  attr_accessor :ta

  def initialize
    @component_list = ComponentsList.new(self)
    @created_list   = CreatedList.new(self)
    @component = ToggleArea.new(self)

    set_components
  end

  def window
    @builder["window1"]
  end

  def before_show
    window.title = "RETerm Designer"
    @builder["component_window"].add(@component_list, :expand => true)
    @builder["created_window"].add(@created_list,     :expand => true)
    @builder["viewer"].add(@component.btn)
    @component.show
    wire_menus
  end  

  def create_component(component, params)
    c = build_component self, component, params
    c, areas = *c if c.is_a?(Array)

    parent = nil
    if @component.is_a?(ToggleArea)
      @builder["viewer"].remove(@component.btn)
      @builder["viewer"].add(c)
      c.show
      areas.each { |a| a.show } if areas

      @component = c

    else
      parent = component_with_toggle_area
      index = parent.child_get_property(@ta.btn, :position)
      parent.remove(@ta.btn)
      parent.add(c, :expand => true)
      parent.child_set_property(c, :position, index)
      c.show
      areas.each { |a| a.show } if areas
    end

    @created_list.register component, params, c, parent

    self.toggle_area = nil
  end

  def remove_component(c)
    if c == @component
      @component = ToggleArea.new(self)
      @builder["viewer"].remove(c)
      @builder["viewer"].add(@component.btn)
      @component.show

    else
      parent = component_with_widget(c)
      index = parent.child_get_property(c, :position)
      parent.remove(c)
      ta = ToggleArea.new(self)
      parent.add(ta.btn, :expand => true)
      parent.child_set_property(ta.btn, :position, index)
      ta.show
    end
  end

  def toggle_area=(ta)
    @ta.toggle_off if has_toggled_area?
    @ta = ta
  end

  # XXX needed as we need to invoke from #toggle_off
  def clear_toggle_area
    @ta = nil
  end

  def has_toggled_area?
    !!@ta
  end

  private

  def component_with_toggle_area(c=component)
    component_with_widget(@ta.btn, c)
  end

  def component_with_widget(widget, c=component)
    return c if c.children.include?(widget)
    c.children.each { |child|
      ch = component_with_widget(widget, child) if child.kind_of?(Gtk::Box)
      return ch unless ch.nil?
    }
    nil
  end

  def set_components
    (RETerm::Layouts.all.sort +
     RETerm::Components.all.sort).each { |c|
      @component_list.add_component c if COMPONENTS.key?(c)
    }
  end

  def wire_menus
    @builder["file_menu_new"].signal_connect("activate") do
      created_list.reset!
    end

    @builder["file_menu_save"].signal_connect("activate") do
      file = FileChooser.new(window).show
      File.write(file, created_list.schema)
    end

    @builder["file_menu_quit"].signal_connect("activate") do
      window.destroy
    end

    @builder["help_menu_about"].signal_connect("activate") do
      About.new
    end
  end
end
