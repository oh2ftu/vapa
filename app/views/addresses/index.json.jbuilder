json.array!(@addresses) do |address|
  json.extract! address, :id, :line1, :line2, :city, :zip, :addressable_id, :addressable_type
  json.url address_url(address, format: :json)
end
