class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
  # 加上自訂欄位到 Devise 的註冊和編輯頁面
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar, :role, :intro])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :role, :intro])
  end
end
