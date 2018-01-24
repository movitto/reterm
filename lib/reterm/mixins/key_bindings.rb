module RETerm
  # Similar to the bindings mixin in the CDK library
  module KeyBindings
    def key_bindings
      @key_bindings ||= {}
    end

    def bind_key(key, kcb=nil, &bl)
      key_bindings[key] ||= []
      kcb = bl if kcb.nil? && !bl.nil?
      key_bindings[key]  << kcb
    end

    def key_bound?(key)
      key_bindings.key?(key)
    end

    def invoke_key_bindings(key)
      o = self
      key_bindings[key].all? { |kcb| kcb.call(o, key) }
    end
  end # module ButtonBindings
end # module RETerm
