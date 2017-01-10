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
      tell_server(MessageType::ClientJoin, @name)

      message = "Connected to Bittern server on #{@host}:#{@port} as #{@name}"
      puts message.colorize(:green)

      process_incoming_message()

      loop do
        input = gets

        break unless process_user_input(input)
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

    def process_user_input(input)
      if input.nil? || input == "/exit"
        tell_server(MessageType::ClientLeave)
        return false
      elsif input == "/list"
        tell_server(MessageType::ClientList)
      else
        tell_server(MessageType::ClientMessage, input)
      end

      return true
    end

    def tell_server(mtype : MessageType, content = "")
      message = Message.new(mtype, content)
      @socket.write(message.serialize.to_slice)
    end
  end
end
