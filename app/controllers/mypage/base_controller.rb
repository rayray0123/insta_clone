# accounts_controllerの親コントローラー
class Mypage::BaseController < ApplicationController
  before_action :require_login
  # Mypage::BaseControllerのアクションとそれを継承するコントローラーのアクションで
  # レンダリングされるレイアウトは「app/views/layouts/Mypage.html.slim」が選択される。
  layout 'mypage'
end
