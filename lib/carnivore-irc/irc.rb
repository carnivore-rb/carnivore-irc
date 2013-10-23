require 'baseirc'
require 'carnivore'
require 'celluloid/io'

require 'carnivore-irc/util/factory'
require 'carnivore-irc/util/socket'

module Carnivore
  class Source
    class Irc < Source

      attr_reader :password, :irc
      attr_accessor :nickname, :username, :real_name, :socket

      def setup(args={})
        @servers = args[:servers].is_a?(Hash) ? [args[:servers]] : args[:servers]
        @current_servers = @servers.dup
        @nickname = args[:nickname]
        @password = args[:password]
        @username = args[:username] || nickname
        @real_name = args[:real_name] || nickname
      end

      def cycle_connect
        server = nil
        while(@socket.nil? || !@socket.alive?)
          begin
            @current_servers = @servers.dup if @current_servers.empty?
            server = @current_servers.pop
            debug "Attempting connection: `#{server.inspect}`"
            @socket = TCPSocket.new(server[:host], server[:port])
            @socket.setsockopt(::Socket::SOL_SOCKET, ::Socket::SO_KEEPALIVE, true)
            raise 'Failed to connect' if @socket.closed?
            info "Connection established: `#{server.inspect}`"
            if(server[:ssl])
              @socket = SSLSocket.new(@socket)
              info 'Socket connection is now SSL wrapped'
            end
            @socket = Carnivore::Irc::Util::Socket.new(@socket)
          rescue => e
            error "Failed to connect: #{e} - `#{server.inspect}`"
            sleep(5)
            retry
          end
        end
      end

      # TODO: Hook factory here so we can grab errors (socket
      # disconnect) and rebuild the connection
      def connect
        cycle_connect
        @irc = BaseIRC::IRC.new(socket)
        irc.nick(nickname)
        irc.user(username, 8, real_name)
        if(password)
          irc.pass(password)
        end
        if(factory)
          callback_supervisor.unlink(factory)
          factory.terminate
        end
        callback_supervisor.supervise_as("factory_#{name}", Carnivore::Irc::Util::Factory,
          :socket => socket,
          :notify => current_actor
        )
        debug "Starting production"
        factory.async.produce
        debug "Production in progress"
      end

      def factory
        Celluloid::Actor["factory_#{name}".to_sym]
      end

      def receive(*args)
        debug "Waiting for messages"
        wait(:eye_are_see)
        debug "Got messages"
        factory.retrieve_messages
      end

    end
  end
end
