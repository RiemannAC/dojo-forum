class CategoriesController < ApplicationController
  # _post_nav 顯示異常修正：點選分類後按 sort_link，all 分類會變 active
  # template 同 posts#index
  def show
    @category = Category.find(params[:id])
    @categories = Category.all
    @q = @category.posts.are_public?.where(authority: "all").or(@category.posts.are_viewable?(current_user).are_public?).ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:comments).page(params[:page]).per(20)
  end
end
