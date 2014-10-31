json.array!(@service_events) do |service_event|
  json.extract! service_event, :id
  json.url service_event_url(service_event, format: :json)
end
