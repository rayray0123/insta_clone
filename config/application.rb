require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InstaClone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.generators do |g|
      g.assets false # CSS,JavaScriptファイルを生成しない
      g.test_framework false # testファイルを生成しない
      g.helper false            # helperファイルを生成しない
      g.skip_routes true        # trueならroutes.rb変更せず、falseなら通常通り変更
    end

    # 自動生成されるファイルをerbからslim形式に変更
    config.generators.template_engine = :slim

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    # sidekiqをバックグラウンドジョブを動かすアダプタとして設定
    # sidekiq を使うためには Client, Redis, Server の 3 つが必要
    # Client → アプリケーション自身、 Server → bundle exec sidekiq で実行
    config.active_job.queue_adapter = :sidekiq
  end
  require 'active_model/railtie'
  require 'active_job/railtie'
  require 'active_record/railtie'
  require 'active_storage/engine'
  require 'action_controller/railtie'
  require 'action_mailer/railtie'
  require 'action_view/railtie'
  require 'action_cable/engine'
  require 'sprockets/railtie'
end
