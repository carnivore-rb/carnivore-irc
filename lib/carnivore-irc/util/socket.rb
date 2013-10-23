module Carnivore
  module Irc
    module Util
      class Socket

        attr_reader :socket, :options

        def initialize(socket, opts={})
          @options = opts.dup
          @socket = socket
          @alive = true
        end

        def kill
          @alive = false
        end

        def alive?
          !!@alive
        end

        def write(m)
          socket << "#{m}\n"
          socket.flush
        end
        alias_method :<<, :write

      end
    end
  end
end
