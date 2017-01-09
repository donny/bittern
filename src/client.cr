module Bittern
  class Client
    @host : String
    @port : Int32
    @name : String

    def initialize(@option : Option)
      @host = @option.server_address
      @port = @option.server_port.to_i
      @name = @option.client_name || "Anonymous"
      @socket = TCPSocket.new(@host, @port)
    end

    def run
      puts "Client"

      process_incoming_message()
      tell_server(MessageType::ClientJoin, @name)

      loop do
        input = gets

        if input.nil? || input == "exit"
          tell_server(MessageType::ClientLeave)
          break
        else
          tell_server(MessageType::ClientMessage, input)
        end
      end
      @socket.close
    end

    def process_incoming_message
      spawn do
        loop do
          response = @socket.gets
          if response.nil?
            @socket.close
            break
          else
            puts response
          end
        end
      end
    end

    def tell_server(mtype : MessageType, content = "")
      message = Message.new(mtype, content)
      @socket.write(message.serialize.to_slice)
    end
  end
end
