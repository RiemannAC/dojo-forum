class Admin::CategoriesController < Admin::BaseController

  def index
    @categories = Category.all
    if params[:id]
      @category = Category.find(params[:id])
    else
      @category = Category.new
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category was successfully created"
      redirect_to admin_categories_path
    else
      @categories = Category.all
      render :index
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

end