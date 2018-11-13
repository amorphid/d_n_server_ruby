json.extract! record, :id, :zone_id, :name, :record_type, :record_class, :ttl, :rdata, :created_at, :updated_at
json.url record_url(record, format: :json)
