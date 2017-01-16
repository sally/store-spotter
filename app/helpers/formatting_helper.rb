module FormattingHelper

  def self.format_address(store)
    puts <<-ADDRESS.gsub(/^ {4}/, '')

      #{store.store_name}
      #{store.store_location}
      #{store.address}
      #{store.city}, #{store.state} #{store.zip_code}

    ADDRESS
  end

end
