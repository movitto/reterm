COMPONENTS = {
  :generic => {
    :params => {
      "Fill"   => :bool,
      "Expand" => :bool
    }
  },

  # Layouts
  :Horizontal => {
    :desc => "Horizontal Layout",
    :params => {
      "Columns" => :int
    }
  },

  :Vertical => {
    :desc => "Vertical Layout",
    :params => {
      "Rows" => :int
    }
  },

  :AsciiText => {
    :desc => "Text Rendered Using Ascii Font",
    :params => {
      "Text" => :string
    },

    :init_keys => ["text"]
  },

  :Button => {
    :desc => "Clickable Button",
    :params => {
      "Text" => :string
    },

    :init_keys => ["text"]
  },

  :Dial => {
    :desc => "Rotatable Dial"
  },

  #:Dialog => {
  #  :desc => "Popup Dialog"
  #},

  :Entry => {
    :desc => "Text Entry",
    :params => {
      "Title" => :string,
      "Label" => :string
    },

    :init_keys => ["title", "label"]
  },

  :HSlider => {
    :desc => "Horizontal Slider"
  },

  :Image => {
    :desc => "Image rendered with ascii art",
    :params => {
      "Path" => :string
    },

    :init_keys => ["file"]
  },

  :Label => {
    :desc   => "Static String",
    :params => {
      "Text" => :string
    },

    :init_keys => ["text"]
  },

  :Matrix => {
    :desc => "X/Y grid",
    :params => {
      "Rows" => :int,
      "Columns" => :int
    },

    :init_keys => ["rows", "cols"]
  },

  :Radio => {
    :desc => "Choice selection control",

    :params => {
      "Choices" => [:string]
    }
  },

  :Rocker => {
    :desc => "Toggleable input",

    :params => {
      "Choices" => [:string]
    },

    :init_keys => ["items"]
  },

  :SList => {
    :desc => "Selectable List of Items",

    :params => {
      "Choices" => [:string]
    },

    :init_keys => ["items"]
  },

  :VSlider => {
    :desc => "Vertical Slider"
  }
}
