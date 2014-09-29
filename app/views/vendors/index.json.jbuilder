json.array!(@vendors) do |vendor|
  json.extract! vendor, :id, :name, :address, :city, :contact, :phone, :email, :notes, :billing
  json.url vendor_url(vendor, format: :json)
end
