require "socket"

module Bittern
  class Server
    @host : String
    @port : Int32
    @connected_clients = [] of TCPSocket

    def initialize(@option : Option)
      @host = @option.server_address
      @port = @option.server_port.to_i
      @server = TCPServer.new(@host, @port)
    end

    def run
      puts "Server"
      loop do
        socket = @server.accept
        @connected_clients.push(socket)
        process_connection(socket)
      end
    end

    def process_connection(socket)
      spawn do
        loop do
          message = socket.gets
          if message.nil?
            socket.close
            break
          else
            message += "\n"

            puts message

            @connected_clients.map do |client|
              client.write(message.to_slice)
            end
          end
          break if socket.closed?
        end
      end
    end
  end
end
