require "./src/*"

if Bittern::CLI.run(ARGV)
  exit
else
  exit -1
end
