require "json"

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
  regex = Regexp.new(query, Regexp::IGNORECASE)
  file_content = File.read("clients.json")
  data = JSON.parse(file_content)
  match_found = false
  data.each do |line|
    if line["full_name"] =~ regex
      match_found = true
      puts "Match: #{line.inspect}"
    end
  end
  puts "No match found" unless match_found
when "duplicates_by_email"
  seen = Hash.new { |h, k| h[k] = [] }
  file_content = File.read("clients.json")
  clients = JSON.parse(file_content)
  clients.each do |client|
    seen[client["email"]] << client
  end
  duplicates = seen.select { |_, v| v.size > 1 }
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
