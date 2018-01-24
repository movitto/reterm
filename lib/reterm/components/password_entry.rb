module RETerm
  module Components
    class PasswordEntry < Entry
      def disp_type
        :HMIXED
      end

      def _component
        c = super
        c.setHiddenChar('#'.ord)
        c
      end
    end # class PasswordEntry
  end # module Components
end # module RETerm
