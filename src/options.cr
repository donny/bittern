require "option_parser"

module Bittern
  class Options
    property parser : OptionParser?
    property show_help : Bool = false
    property show_version : Bool = false

    def initialize
    end

    def self.parse(args)
      new.tap do |options|
        options.parser = OptionParser.parse(args) do |parser|
          parser.banner = "Usage: bittern [method] URL [options]"
          parser.separator
          parser.on("-n NAME", "--name NAME", "Specifies the user's name") { |name| destination = name }
          parser.on("-h", "--help", "Show this help") { options.show_help = true }
          parser.on("-v", "--version", "Display version") { options.show_version = true }
        end
      end
    end
  end
end
