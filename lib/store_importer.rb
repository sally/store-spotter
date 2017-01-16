module StoreImporter

  def self.import(filename = File.dirname(__FILE__) + "/../db/store-locations.csv")
    csv = CSV.parse(File.read(filename))
    headers = csv.shift.map {|header| header.downcase.gsub(" ", "_")}
    headers[0] = headers[0][1..-1]
    csv.each {|location| Store.create(Hash[headers.zip(location)])}
  end

end
