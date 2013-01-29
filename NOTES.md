NOTES
=====

Just some basic notes here on command-line Ruby scripting. I'm sure that not all
of this will end up useful.

* Some repos have renamed README files. E.g. rails-intro's readme was initially
  named README.md, but was renamed to README.rdoc

* Accessing the OSX keychain
  - https://gist.github.com/668628

* Executing commands
  - Two different formats:
    `` %x(echo hi) ``
    `` `echo hi` `` # (Note the literal backticks here.)

* Getting user input
  - Just store it in a var:
    ``
    puts "Your message here"
    stored_input = gets.chomp  # Chomp removes the \n typically stored by gets
    ``
