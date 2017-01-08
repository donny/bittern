require "option_parser"

module Bittern
  class Option
    property parser : OptionParser?
    property show_help : Bool = false
    property show_version : Bool = false

    property server_mode : Bool = true
    property server_address : String = "localhost"
    property server_port : String = "8177"
    property client_name : String?

    property errors : Array(Exception) = [] of Exception

    def initialize
    end

    def self.parse(args)
      new.tap do |option|
        option.parser = OptionParser.parse(args) do |parser|
          parser.banner = "Usage: bittern [options]"
          parser.separator
          parser.on("-a ADDRESS", "--address ADDRESS", "Specifies the server's address") do |address|
            option.server_address = address
          end
          parser.on("-p PORT", "--port PORT", "Specifies the server's port number") do |port|
            option.server_port = port
          end
          parser.on("-c NAME", "--client NAME", "Connects as a client using name") do |name|
            option.server_mode = false
            option.client_name = name
          end
          parser.on("-h", "--help", "Show this help") { option.show_help = true }
          parser.on("-v", "--version", "Display version") { option.show_version = true }

          parser.invalid_option do |opt|
            option.errors << Exception.new("Invalid option: #{opt}")
          end

          parser.missing_option do |opt|
            option.errors << Exception.new("Missing argument: #{opt}")
          end
        end
      end
    end
  end
end
