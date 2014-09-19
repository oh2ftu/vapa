json.array!(@categories) do |category|
  json.extract! category, :id, :acronym, :name
  json.url category_url(category, format: :json)
end
