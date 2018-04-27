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

    # 帶分類測試網址 DNS/api/v1/posts?category_id=1
    if params[:category_id]
      render json: {
        category:
          {
            name: @category.name
          },
        posts_data: @posts.map do |post|
          {
            title: post.title,
            content: post.content,
            authority: post.authority,
            status: post.status,
            image: post.image
          }
        end
      }
    else
      render json: {
        message: "測試分類網址 https://www.riemann.xyz/api/v1/posts?category_id=1",
        posts_data: @posts.map do |post|
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

  def create
    # @user = User.find_by_id(9)  # 測試用
    # @post = @user.posts.build(post_params) # 測試用
    @post = current_user.posts.build(post_params)
    if @post.save
      render json: {
        message: "Post has been created!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def update
    if @post.update(post_params)
      render json: {
        message: "Post updated successfully!",
        result: @post
      }
    else
      render json: {
        errors: @post.errors
      }
    end
  end

  def destroy
    @post.destroy
    render json: {
      message: "Post destroy successfully!"
    }
  end

  private

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  # no require(:post)
  def post_params
    params.permit(:title, :content, :image, :status, :authority, category_ids: [])
  end
end
