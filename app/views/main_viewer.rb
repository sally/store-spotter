module MainViewer
  def self.welcome
    system "clear"
    banner = "   _____ __                 _____             __  __
  / ___// /_____  ________ / ___/____  ____  / /_/ /____  _____
  \\__ \\/ __/ __ \\/ ___/ _ \\\\__ \\/ __ \\/ __ \\/ __/ __/ _ \\/ ___/
 ___/ / /_/ /_/ / /  /  __/__/ / /_/ / /_/ / /_/ /_/  __/ /
/____/\\__/\\____/_/   \\___/____/ .___/\\____/\\__/\\__/\\___/_/
                             /_/
    "
    puts banner
    puts "Find the nearest retail store near you."
  end

  def self.ask_address
    puts "\nEnter your street address (e.g. 8102 Ridings Ct, McLean, VA 22102), or type 'exit' to exit."

    gets.chomp
  end

  def self.show_store(store)
    puts "\nYour closest store is:"
    FormattingHelper.format_address(store)
  end

  def self.bye
    puts "Thanks for using StoreSpotter. :)"
  end
end
