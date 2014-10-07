json.array!(@owners) do |owner|
  json.extract! owner, :id, :name
  json.url owner_url(owner, format: :json)
end
