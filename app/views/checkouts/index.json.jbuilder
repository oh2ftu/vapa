json.array!(@checkouts) do |checkout|
  json.extract! checkout, :id, :user_id, :checkout, :return
  json.url checkout_url(checkout, format: :json)
end
