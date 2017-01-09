module Bittern
  class Client
    @host : String
    @port : Int32

    def initialize(@option : Option)
      @host = @option.server_address
      @port = @option.server_port.to_i
      @socket = TCPSocket.new(@host, @port)
    end

    def run
      puts "Client"

      process_message()

      loop do
        input = gets

        if input.nil? || input == "exit"
          break
        else
          input += "\n"
          @socket.write(input.to_slice)
        end
      end
      @socket.close
    end

    def process_message
      spawn do
        loop do
          response = @socket.gets
          puts response
        end
      end
    end
  end
end
