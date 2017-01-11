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

Bittern is a simple CLI multi user chat system using TCP/IP socket connection. The server can be started by running `crystal bittern.cr -- -a localhost -p 8177`, passing the hostname (default is `localhost`) and the port number (default is `8177`) where the server can listen on. Thus, we could simply start the server by running `crystal bittern.cr`. The client can be started by running `crystal bittern.cr -- -c Alice`, and passing the name of the user as a parameter. By default, the client connects to the server on `localhost:8177`. We could use `-a` and `-p` command line arguments to pass a different server address. The screenshot of the app in several terminal windows:

A movie that shows the app in action can be seen below:

### Implementation

### Conclusion
