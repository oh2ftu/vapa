json.array!(@departments) do |department|
  json.extract! department, :id, :name, :station
  json.url department_url(department, format: :json)
end
