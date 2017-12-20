# List of components created
class CreatedList < VR::TreeView
  attr_accessor :designer, :schema

  attr_accessor :rows_by_parent,
                :rows_by_widget,
                :rows_by_component,
                :params_by_widget

  def initialize(designer)
    @designer = designer

    @rows_by_parent   = {}
    @rows_by_widget   = {}
    @params_by_widget = {}
    @rows_by_component = {}

    @cols = {}
    @cols[:title] = String
    @cols[:rm]    = GdkPixbuf::Pixbuf
    super(@cols)

    col_title(:rm    => "Remove",
              :title => "Component")

    self.activate_on_single_click = true

    self.signal_connect("row_activated") { |*args|
      if args[2] == columns[1]
        path = args[1]
        iter = model.get_iter(path)
        unregister(iter)
      end

      selection.unselect_all
    }
  end

  def register(component, params, widget, parent)
    img = GdkPixbuf::Pixbuf.new(:file => "#{IMG_DIR}/remove.png")

    row             = model.append row_for(parent)
    row[id(:title)] = component.to_s
    row[id(:rm)]    = img

    rows_by_parent[parent] ||= []
    rows_by_parent[parent]  << row

    rows_by_component[component] = row
    rows_by_widget[widget]       = row
    params_by_widget[widget]     = params

    if visible?
      designer.builder["created_window"].visible = true
      show
    end

    @schema = _schema
  end

  def visible?
    rows_by_parent.any? { |k,v| v.size > 0 }
  end

  def parent_for(row)
    rows_by_parent.keys.find { |k|
      rows_by_parent[k].include?(row)
    }
  end

  def row_for(widget)
    rows_by_widget[widget]
  end

  def widget_for(row)
    rows_by_widget.keys.find { |k|
      rows_by_widget[k] == row
    }
  end

  def component_for(row)
    rows_by_component.keys.find { |k|
      rows_by_component[k] == row
    }
  end

  def component_for_widget(widget)
    component_for(row_for(widget))
  end

  def reset!
    unregister(rows_by_parent[nil].first)
  end

  def unregister(row)
    0.upto(row.n_children-1) { |child|
      unregister(row.nth_child(child))
    }

    parent = parent_for(row)
    widget = widget_for(row)
    component = component_for(row)

    rows_by_parent[parent].delete(row)
    rows_by_component.delete(component)
    rows_by_widget.delete(widget)
    params_by_widget.delete(widget)
    model.remove(row)

    designer.remove_component(widget)

    unless visible?
      designer.builder["created_window"].visible = false
      hide
    end

    @schema = _schema
  end

  def _schema
    win = {'window' => {}}

    top = rows_by_parent[nil].first # there should be only one element here
    return win if top.nil?

    tc  = component_for(top)
    wg  = widget_for(top)

    if wg.kind_of?(Gtk::Box)
      win['window']["layout"] = layout_schema(wg)
    else
      win['window']["component"] = {"type" => tc,
                                    "init" => params_for(wg)}
    end

    win
  end

  private

  def params_for(w)
    keys = COMPONENTS[component_for_widget(w)][:init_keys]
    return [] unless keys
    vals = params_by_widget[w]
    Hash[keys.zip(vals)]
  end

  def layout_schema(l)
    h = l.orientation == Gtk::Orientation::HORIZONTAL
    s = {"type" => (h ? "Horizontal" : "Vertical"),
         "children" => []}

    l.children.each { |c|
      next unless component_for_widget(c)
      s["children"] << (c.kind_of?(Gtk::Box) ?
                         layout_schema(c) :
                         {"component" => {
                           "type" => component_for(row_for(c)),
                           "init" => params_for(c)
                         }})
    }

    s
  end
end
