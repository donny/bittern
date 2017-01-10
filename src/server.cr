require "socket"
require "colorize"

module Bittern
  private struct ConnectedClient
    property socket, name
    property color : Symbol

    def initialize(@socket : TCPSocket, @name : String)
      colors = [:red, :green, :yellow, :blue, :magenta, :cyan]
      @color = colors.sample(1).first
    end
  end

  class Server
    @host : String
    @port : Int32
    @connected_clients = {} of TCPSocket => ConnectedClient

    def initialize(@option : Option)
      @host = @option.server_address
      @port = @option.server_port.to_i
      @server = TCPServer.new(@host, @port)
    end

    def run
      message = "Running Bittern server on #{@host}:#{@port}"
      puts message.colorize(:green)
      loop do
        socket = @server.accept
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
            process_client_message(message, socket)
          end
          break if socket.closed?
        end
      end
    end

    def process_client_message(raw_string, socket)
      message = Message.new(raw_string)

      case message.mtype
      when MessageType::ClientJoin
        puts "#{message.content} is joining from #{socket.remote_address}".colorize(:blue)
        @connected_clients[socket] = ConnectedClient.new(socket, message.content)
      when MessageType::ClientLeave
        client = @connected_clients[socket]
        puts "#{client.name} is leaving".colorize(:cyan)
        @connected_clients.delete(socket)
      when MessageType::ClientMessage
        client = @connected_clients[socket]
        output = "#{client.name}:".colorize(client.color).to_s + " #{message.content}\n"
        @connected_clients.each_value do |client|
          client.socket.write(output.to_slice)
        end
      when MessageType::ClientList
        client = @connected_clients[socket]
        output = "List of people:"
        @connected_clients.each_value do |client|
          output += " #{client.name}"
        end
        output = output.colorize.mode(:underline).to_s
        output += "\n"
        client.socket.write(output.to_slice)
      else
        puts "ERROR".colorize(:red)
      end
    end
  end
end
