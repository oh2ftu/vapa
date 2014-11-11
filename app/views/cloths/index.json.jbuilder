json.array!(@cloths) do |cloth|
  json.extract! cloth, :id, :user_id, :name, :size, :amount, :issued
  json.url cloth_url(cloth, format: :json)
end
