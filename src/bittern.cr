module Bittern
  module CLI
    def self.run(argv, output)
      options = Options.parse(argv)

      if options.show_help
        output.puts options.parser
        return true
      end

      if options.show_version
        output.puts Bittern.version_string
        return true
      end
    end
  end
end
