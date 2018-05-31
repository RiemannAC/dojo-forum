class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :collect, :uncollect]

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
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    else
      @post.status = "public"
      if @post.save
        redirect_to user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :new
      end
    end
  end

  def show
    if @post.authority?(current_user)
      @post.vieweds.create(user: current_user) unless @post.seen_by?(current_user)
      @comments = @post.comments.includes(:user).page(params[:page]).per(8)
      @comment = Comment.new
    else
      flash[:alert] = "Not Allowed!"
      redirect_to posts_path
    end
  end

  def update
    if params[:draft]
      @post.status = "draft"
      if @post.update(post_params)
        flash[:notice] = "Draft already saved!"
        redirect_to drafts_user_path(current_user)
      else
        flash.now[:alert] = @post.errors.full_messages.to_sentence
        render :edit
      end
    else
      @post.status = "public"
      if @post.update(post_params)
        flash[:notice] = "Post already published!"
        redirect_to user_path(current_user)
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
      redirect_to user_path(current_user)
    else
      @post.destroy
      flash[:notice] = "Draft has been deleted!"
      redirect_to drafts_user_path(current_user)
    end
  end

  # 失敗待修
  def edit_comment
    # set_post 和 comments_controller 不一樣 看 URI Pattern
    @post = Post.find(params[:id])
    # post_id = params[:post_id]
    # @post = Post.find(params[:post_id])
    @comment = @post.comments.find_by(id: params[:comment_id])# (comment_id: comment_id)
    # comment_id = params[:comment_id]
    # @comment = @post.comments.where(id: :comment_id)
    if @comment.update(comment_params)
      flash[:notice] = "Comment already updated!"
      redirect_to post_path(@post)
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
      render :edit_comment
    end
  end

  def collect
    @post.collections.create(user: current_user)
    redirect_back(fallback_location: root_path)
  end

  def uncollect
    # @collect = @post.collections.find_by(user: current_user)
    @collect = Collection.where(post: @post, user: current_user)
    @collect.destroy_all
    redirect_back(fallback_location: root_path)
  end

  private

  # permit an array with strong parameters
  def post_params
    params.require(:post).permit(:title, :content, :image, :status, :authority, category_ids: [])
  end

  def set_post
    @post = Post.find(params[:id])
  end

  # 失敗待修
  def comment_params
    # params.require.(:post, :comment).permit(:content)
    # params.require.(:post).permit(:content)
    # params.require.(:edit_comment).permit(:comment, :post, :content)
    # params.permit(:content) # 自動 show 出 "Comment already updated!"
    # params.require(:comment).permit(:content) # param is missing or the value is empty: comment
    # params.require.(:comment, :post).permit(:content) # wrong number of arguments (given 0, expected 1)
    # params.require.(:comment).permit(:content).permit(:post)
    # params.require.(:comment).require(:post).permit(:content)
    params.require.(:comment).permit(:post, :content)
  end

end
