class Api::V1::PostsController < ApiController
  before_action :authenticate_user!, except: :index
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    if current_user
      if params[:category_id]
        @category = Category.find_by(id: params[:category_id])
        @posts = @category.posts.are_viewable?(current_user).are_public?.includes(:comments).page(params[:page]).per(20)
      else
        @posts = Post.are_viewable?(current_user).are_public?.includes(:comments).page(params[:page]).per(20)
      end
    else
      if params[:category_id]
        @category = Category.find_by(id: params[:category_id])
        @posts = @category.posts.are_public?.where(authority: "all").includes(:comments).page(params[:page]).per(20)
      else
        @posts = Post.are_public?.where(authority: "all").includes(:comments).page(params[:page]).per(20)
      end
    end
    render json: {
      data: @posts.map do |post|
        {
          title: post.title,
          content: post.content,
          authority: post.authority,
          status: post.status,
          image: post.image
        }
      end
    }
  end

  def show
    if !@post
      render json: {
        message: "Can't find the post!",
        status: 400
      }
    else
      if @post.authority?(current_user)
        @post.vieweds.create(user: current_user) unless @post.seen_by?(current_user)
        @comments = @post.comments
          render json: {
            post:
              {
                title: @post.title,
                content: @post.content,
                authority: @post.authority,
                status: @post.status,
                image: @post.image
              },
            comments_data: @comments.map do |comment|
              {
                content: comment.content
              }
            end
          }
      else
        render json: {
          errors: "Not Allowed!",
          status: 403
        }
      end
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end
