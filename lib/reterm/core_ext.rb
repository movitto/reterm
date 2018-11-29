# Enumerable#sum introduced in Ruby 2.4
if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.4')
  # Copied from active_support
  module Enumerable
    def sum(identity = 0, &block)
      if block_given?
        map(&block).sum(identity)
      else
        inject { |sum, element| sum + element } || identity
      end
    end
  end # module Enumerable
end
