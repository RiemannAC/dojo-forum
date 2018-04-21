class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:index]
  # devise：user 新增欄位給值
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def authenticate_admin
    unless current_user.admin?
      flash[:alert] = "Not allow!"
      redirect_to root_path
    end
  end

  # 加上自訂欄位到 Devise 的註冊和編輯頁面
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar, :role, :intro])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar, :role, :intro])
  end
end
