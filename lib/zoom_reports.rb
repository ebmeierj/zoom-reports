require 'dotenv'
Dotenv.load

# Load all ruby files in the current directory, recursive
PROJECT_DIR = File.realpath(File.dirname(File.dirname(__FILE__))).to_s
puts "PROJECT DIR IS #{PROJECT_DIR}"
$LOAD_PATH.unshift(PROJECT_DIR)

Dir["#{PROJECT_DIR}/lib/**/*.rb"].sort.each { |file| require file.sub("#{PROJECT_DIR}/", '').chomp('.rb') }
