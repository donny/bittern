require "socket"

clients = [] of TCPSocket

server = TCPServer.new("localhost", 1234)
loop do
  puts "A"
  socket = server.accept
  clients.push(socket)
  process_connection(socket, clients)

  # server.accept do |client|
  #   message = client.gets
  #   puts message
  #   client << message # echo the message back
  # end
end

def process_connection(socket, clients)
  puts "B"
  spawn do
    puts "C"
    loop do
      puts "D"
      message = socket.gets
      puts message
      if message.nil?
        socket.close
        break
      else
        puts "E"

        message += "\n"

        clients.map do |cl|
          val = cl.write(message.to_slice)
          puts val
        end

        # val = socket.write(message.to_slice)
        # puts val
      end
      break if socket.closed?
    end
    puts "END"
  end
end

# require "socket"
#
# ch = Channel(TCPSocket).new
#
# 10.times do
#   spawn do
#     loop do
#       socket = ch.receive
#       socket.puts "Hi!"
#       socket.close
#     end
#   end
# end
#
# server = TCPServer.new(1234)
# loop do
#   socket = server.accept
#   ch.send socket
# end
