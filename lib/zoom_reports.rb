require 'dotenv'
Dotenv.load

# Load all ruby files in the current directory, recursive
base_directory = File.realpath(File.dirname(__FILE__)).to_s
Dir["#{base_directory}/**/*.rb"].sort.each { |file| require_relative file.sub("#{base_directory}/", '').chomp('.rb') }
