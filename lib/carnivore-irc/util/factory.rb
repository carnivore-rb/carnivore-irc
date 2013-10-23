require 'messagefactory'

module Carnivore
  module Irc
    module Util
      class Factory

        include Celluloid
        include Celluloid::IO
        include Carnivore::Utils::Logging

        attr_reader :socket, :factory, :notify, :messages

        def initialize(args={})
          @socket = args[:socket]
          @factory = MessageFactory::Factory.new
          @notify = args[:notify]
          @messages = []
          validate!
        end

        def retrieve_messages
          msgs = @messages.dup
          @messages.clear
          msgs
        end

        def validate!
          unless(socket)
            raise ArgumentError.new('Expecting `IO` instance via `:socket`')
          end
          unless(notify)
            raise ArgumentError.new('Expecting `Actor` instance via `:notify`')
          end
        end

        def produce
          defer do
            while(socket.alive?)
              string = socket.socket.gets.to_s
              debug "Raw receive: #{string}"
              unless(string.empty?)
                messages << factory.process(string.to_s)
                messages.compact!
              else
                error 'Got an empty string response. Something is wrong with this connection.'
                socket.kill
              end
              notify.signal(:eye_are_see) unless messages.empty?
            end
          end
        end

      end
    end
  end
end
