module RETerm
  # XXX copied from CDK
  module CommonControls
    attr_reader :quit_on_enter

    def quit_on_enter=(v)
      @quit_on_enter_set = true
      @quit_on_enter = v
    end

    def quit_on_enter?
      @quit_on_enter_set ? @quit_on_enter : true
    end
  end # module CommonControls
end # module CDK
