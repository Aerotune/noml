require 'pp'
require_relative 'noml'

parsed_noml = Noml.parse_file './example_files/random.noml'
pp parsed_noml