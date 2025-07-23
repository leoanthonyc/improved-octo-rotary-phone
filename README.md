## ShiftCare Technical Challenge

### Description
You are tasked with building a command-line application using Ruby. Given a JSON dataset with clients (attached), the application will need to offer two commands:
* Search through all clients and return those with names partially matching a given search query
* Find out if there are any clients with the same email in the dataset, and show those duplicates if any are found.


### Setup
```bash
git clone https://github.com/leoanthonyc/improved-octo-rotary-phone.git
cd improved-octo-rotary-phone
bundle install
```

### Usage
```bash
# Find clients having their full name partially/fully matching the given query
ruby sc.rb find_by_name <query>

# Find clients having the same email
ruby sc.rb duplicates_by_email
```

### Challenges
1. How to name the commands, class names

### Limitations
1. It loads the entire content into memory, which can be inefficient or impossible when the file is too large.
2. The search command is only limited to one field, `full_name`.
