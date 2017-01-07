require "./src/*"

if Bittern::CLI.run(ARGV, STDOUT)
  exit
else
  exit -1
end
