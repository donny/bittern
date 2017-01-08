module Bittern
  module CLI
    def self.run(argv, output)
      option = Option.parse(argv)

      if option.show_help
        output.puts option.parser
        return true
      end

      if option.show_version
        output.puts Bittern.version_string
        return true
      end

      if option.errors.any?
        output.puts option.parser
        output.puts
        output.puts "Errors:"
        option.errors.each do |error|
          output.puts "  * " + error.to_s
        end
        output.puts
        return false
      end
    end
  end
end
