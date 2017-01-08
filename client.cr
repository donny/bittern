require "socket"

client = TCPSocket.new("localhost", 1234)

spawn do
  loop do
    response = client.gets
    puts response
  end
end

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
