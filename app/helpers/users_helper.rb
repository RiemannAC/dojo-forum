module UsersHelper
  def request_friend(user)
    unless @user.friend?(user)#已成朋友後，不顯示雙向請求
      render partial: "shared/user_item", locals: { user: user }
    end
  end

  # user_info 若顯示按鈕 => return true
  def user_button?(user)
    return true if user == current_user || !current_user.inverse_request_friend?(user)
  end

end
