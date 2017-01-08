require "socket"

client = TCPSocket.new("localhost", 1234)

process_message(client)

# Main loop
loop do
  input = gets

  if input.nil? || input == "exit"
    break
  else
    input += "\n"
    client.write(input.to_slice)
  end
end

client.close

# Functions

def process_message(client)
  spawn do
    loop do
      response = client.gets
      puts response
    end
  end
end
