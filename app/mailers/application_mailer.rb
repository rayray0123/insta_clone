class ApplicationMailer < ActionMailer::Base
  # デフォルトの差出人設定
  default from: 'instaclone@example.com'
  layout 'mailer'
end
