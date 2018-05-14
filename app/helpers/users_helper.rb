module UsersHelper
  def request_friend(user)
    unless @user.friend?(user)#已成朋友後，不顯示雙向請求
      render partial: "shared/user_item", locals: { user: user }
    end
  end
end
