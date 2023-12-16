database_path = ActiveRecord::Base.connection_db_config.database

Litestream.configure do |config|
  config.database_path = database_path
  config.replica_url = "s3://devbkt.localhost:9000/#{File.basename(database_path)}"
  config.replica_key_id = "minioadmin"
  config.replica_access_key = "minioadmin"
end
