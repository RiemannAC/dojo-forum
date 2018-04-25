class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    if current_user            # 已登入使用者 public post & are_viewable? check
      if params[:category_id]  # 有分類 post
        @category = Category.find(params[:category_id])
        @posts = @category.posts.are_viewable?(current_user).are_public?.includes(:comments).page(params[:page]).per(20)
      else                     # 無分類 post
        @posts = Post.are_viewable?(current_user).are_public?.includes(:comments).page(params[:page]).per(20)
      end
    else                       # 未登入使用者 public post & authority all
      if params[:category_id]  # 有分類 post
        @category = Category.find(params[:category_id])
        @posts = @category.posts.are_public?.where(authority: "all").includes(:comments).page(params[:page]).per(20)
      else                     # 無分類 post
        @posts = Post.are_public?.where(authority: "all").includes(:comments).page(params[:page]).per(20)
      end
    end
  end

  def new
    @post = Post.new
  end

  # multi submit
  def create
    @post = current_user.posts.build(post_params)
    if params[:draft]
      @post.status = "draft"
      if @post.save
        # redirect_to drafts_user_path(current_user)
        redirect_to root_path
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    else
      @post.status = "public"
      if @post.save
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    end
  end

  def show
    @comments = @post.comments.includes(:user).page(params[:page]).per(8)
    @comment = Comment.new
  end

  def update
    if params[:draft]
      @post.status = "draft"
      if @post.update(post_params)
        flash[:notice] = "Draft already saved!"
        # redirect_to drafts_user_path(current_user)
        redirect_to root_path
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    else
      @post.status = "public"
      if @post.update(post_params)
        flash[:notice] = "Post already published!"
        redirect_to post_path(@post)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    end
  end

  def destroy
    if @post.status = "public"
      @post.destroy
      flash[:notice] = "Post has been deleted!"
      redirect_to posts_path
    else
      @post.destroy
      flash[:notice] = "Draft has been deleted!"
      redirect_to drafts_user_path(current_user)
    end
  end

  private

  # permit an array with strong parameters
  def post_params
    params.require(:post).permit(:title, :content, :image, :status, :authority, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

end
