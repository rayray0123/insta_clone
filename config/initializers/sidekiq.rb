# Sidekiqが接続するredisを記述
Sidekiq.configure_server do |config|
  config.redis = {
      urll: 'redis://localhost:6379'
  }
end
Sidekiq.configure_client do |config|
  config.redis = {
      url: 'redis://localhost:6379'
  }
end
