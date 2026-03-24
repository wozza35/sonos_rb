#!/usr/bin/env ruby

puts "SonosRB CLI started. Type 'exit' to quit."

loop do
  print "> "
  input = gets&.chomp
  break if input.nil? || input == "exit"
end

puts "Goodbye!"
