module RETerm
  # Helper mixin defining methods to register event
  # handlers and dispatch events. Events are simply
  # composed parameters which are passed to the
  # callback blocks when dispatched
  module EventDispatcher
    def dispatch(e, h={})
      @event_handlers ||= {}
      @event_handlers[e].each { |eh|
        eh.call h
      } if @event_handlers.key?(e)
    end

    def handle(e, &bl)
      @event_handlers    ||= {}
      @event_handlers[e] ||= []
      @event_handlers[e]  << bl
    end
  end # module EventDispatcher
end # module RETerm
