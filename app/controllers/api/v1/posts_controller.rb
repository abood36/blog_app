class Api::V1::PostsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user, only: [:update, :destroy]

  def index
    posts = Post.all
    render json: posts
  end

  def create
    post = current_user.posts.new(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end

  def authorize_user
    render json: { error: 'Not Authorized' }, status: :forbidden unless @post.user == @current_user
  end
  
  def set_post
    @post = Post.find(params[:id])
  end
end
