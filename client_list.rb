require "json"

module ClientList
  def self.find_by_name(file_path, name)
    name_regex = Regexp.new(name, Regexp::IGNORECASE)
    clients = JSON.parse(File.read(file_path))
    clients.select { |client| client["full_name"] =~ name_regex }
  end

  def self.duplicates_by_email(file_path)
    seen = Hash.new { |h, k| h[k] = [] }
    clients = JSON.parse(File.read(file_path))
    clients.each do |client|
      seen[client["email"]] << client
    end
    seen.select { |_, v| v.size > 1 }
  end

  def self.find_by(file_path, args)
    clients = JSON.parse(File.read(file_path))
    conditions = args.map do |arg|
      key, value = arg.split("=")
      if key.nil? || value.nil?
        puts "Skipping invalid argument: #{arg}"
        next
      end
      [key, value]
    end.compact.to_h
    clients.select do |client|
      conditions.all? { |k,v| client[k]&.to_s == v }
    end
  end
end
