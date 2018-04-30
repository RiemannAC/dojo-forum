class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:update, :destroy]

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

  def update
    if @category.update(category_params)
      flash[:notice] = "Category was successfully updated!"
      redirect_to admin_categories_path
    else
      @categories = Category.all
      render :index
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = "Category was successfully deleted!"
      redirect_to admin_categories_path
    else
      flash[:alert] = @category.errors.full_messages.to_sentence
      redirect_to admin_categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

end