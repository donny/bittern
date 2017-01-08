module Bittern
  module CLI
    def self.run(argv)
      option = Option.parse(argv)

      if option.show_help
        puts option.parser
        return true
      end

      if option.show_version
        puts Bittern.version_string
        return true
      end

      if option.errors.any?
        puts option.parser
        puts
        puts "Errors:"
        option.errors.each do |error|
          puts "  * " + error.to_s
        end
        puts
        return false
      end
    end
  end
end
