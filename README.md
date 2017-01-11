# bittern

Bittern is a command-line interface (CLI) multi user chat system written in [Crystal](https://crystal-lang.org) using TCP/IP socket connection.

### Background

This project is part of [52projects](https://donny.github.io/52projects/) and the new stuff that I learn through this project: the [Crystal](https://crystal-lang.org) programming language.

### Crystal Language

As described in [Wikipedia](https://en.wikipedia.org/wiki/Crystal_(programming_language)), Crystal is a general-purpose, object-oriented programming language with syntax inspired by Ruby. It has several [language goals](https://crystal-lang.org):

- Have a syntax similar to Ruby (but compatibility with it is not a goal).
- Statically type-checked but without having to specify the type of variables or method arguments.
- Be able to call C code by writing bindings to it in Crystal.
- Have compile-time evaluation and generation of code, to avoid boilerplate code.
- Compile to efficient native code.

And it looks something like this:

```crystal
# A very basic HTTP server
require "http/server"

server = HTTP::Server.new(8080) do |context|
  context.response.content_type = "text/plain"
  context.response.print "Hello world, got #{context.request.path}!"
end

puts "Listening on http://127.0.0.1:8080"
server.listen
```

Crystal compiles to native code using an [LLVM](http://llvm.org) backend. Thus, we could do something like:

```shell
$ cat hello.cr
puts "Hello World"
$ crystal build hello.cr
$ file hello
hello: Mach-O 64-bit executable x86_64
$ ./hello
Hello World
```

This improves performance since the code is compiled rather than interpreted. Furthermore, it leverages LLVM optimisation passes such as dead code elimination, function inlining, etc. Crystal has extensive [documentation](https://crystal-lang.org/docs/) and [API reference](https://crystal-lang.org/api).

### Project

Bittern is a simple CLI multi user chat system using TCP/IP socket connection. The server can be started by running `crystal bittern.cr -- -a localhost -p 8177`, passing the hostname (default is `localhost`) and the port number (default is `8177`) where the server can listen on. Thus, we could simply start the server by running `crystal bittern.cr`. The client can be started by running `crystal bittern.cr -- -c Alice`, and passing the name of the user as a parameter. By default, the client connects to the server on `localhost:8177`. We could use `-a` and `-p` command line arguments to pass a different server address. The app in action is captured in a short [movie](https://raw.githubusercontent.com/donny/bittern/master/movie.mov) while the screenshot of the app in several terminal windows can be seen below:

![Screenshot](https://raw.githubusercontent.com/donny/bittern/master/screenshot.png)

### Implementation

The app is implemented using just Crystal's standard library without using any third party dependencies. In `src` directory, the file [`bittern.cr`](src/bittern.cr) implements the CLI wrapper while command line argument parsing is done by [`option`](src/option.cr) (using Crystal's [`OptionParser`](https://crystal-lang.org/api/0.20.4/OptionParser.html)). A simple client/server protocol is defined in [`message.cr`](src/message.cr) using `enum` and `struct`.

The [concurrency](https://crystal-lang.org/docs/guides/concurrency.html) model of Crystal is inspired by [CSP](https://en.wikipedia.org/wiki/Communicating_sequential_processes) and [Go](https://golang.org). Crystal has fibers where a fiber is similar to a lightweight OS thread and its execution is managed internally by the Crystal process. Crystal has channels that allow fibers to communicate data without sharing memory.

The Bittern [Server](src/server.cr) spawns a fiber (with the function `spawn`) for each incoming connection:

```crystal
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
```

The Bittern [Client](src/client.cr) spawns a fiber to process incoming server messages whilst the main loop handles user interaction:

```crystal
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
```

### Conclusion
