require "option_parser"

module Bittern
  class Options
    property parser : OptionParser?
    property show_help : Bool = false
    property show_version : Bool = false

    property server_address : String = "localhost"
    property server_port : String = "8177"

    property errors : Array(Exception) = [] of Exception

    def initialize
    end

    def self.parse(args)
      new.tap do |options|
        options.parser = OptionParser.parse(args) do |parser|
          parser.banner = "Usage: bittern [method] URL [options]"
          parser.separator
          parser.on("-a ADDRESS", "--address ADDRESS", "Specifies the server's address") do |address|
            options.server_address = address
          end
          parser.on("-p PORT", "--port PORT", "Specifies the server's port number") do |port|
            options.server_port = port
          end
          parser.on("-h", "--help", "Show this help") { options.show_help = true }
          parser.on("-v", "--version", "Display version") { options.show_version = true }

          parser.invalid_option do |option|
            options.errors << Exception.new("Invalid option: #{option}")
          end

          parser.missing_option do |option|
            options.errors << Exception.new("Missing argument: #{option}")
          end
        end
      end
    end
  end
end
