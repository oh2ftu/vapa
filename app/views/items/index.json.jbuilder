json.array!(@items) do |item|
  json.extract! item, :id, :tagid, :rfid, :item_class, :item_subclass, :weight, :description, :purchased_at_date, :purchased_at, :warranty_until, :lifetime_until, :serial, :sku, :price, :owner, :last_seen, :service_interval, :lup
  json.url item_url(item, format: :json)
end
