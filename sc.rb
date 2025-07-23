require 'json'
require_relative './client_list'

puts

command = ARGV.shift
unless command
  puts <<~USAGE
    Usage:
      ruby sc.rb find_by_name <name>
      ruby sc.rb duplicates_by_email
  USAGE
  puts
end

case command
when "find_by_name"
  query = ARGV.shift
  unless query
    puts "Usage: ruby sc.rb find_by_name <name>"
    puts
    exit
  end
  found = ClientList.find_by_name('clients.json', query)
  if found.empty?
    puts "No match found!"
  else
    found.each do |client|
      puts "Match: #{client}"
    end
  end
when "duplicates_by_email"
  duplicates = ClientList.duplicates_by_email("clients.json")
  if duplicates.empty?
    puts "No duplicates found"
  else
    duplicates.each do |email, clients|
      puts "Duplicate email: #{email}"
      clients.each { |c| puts "  #{c}" }
    end
  end
else
  puts "Unknown command"
  puts "Try 'find_by_name' or 'duplicates_by_email'"
end

puts
