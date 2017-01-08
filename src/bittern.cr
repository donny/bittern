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

      if options.errors.any?
        output.puts options.parser
        output.puts
        output.puts "Errors:"
        options.errors.each do |error|
          output.puts "  * " + error.to_s
        end
        output.puts
        return false
      end
    end
  end
end
