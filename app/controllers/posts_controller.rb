class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authorize_owner!, only: %i[ edit update destroy ]

  def index
    @courses = Course.order(:title)

    @posts = Post.includes(:course)

    if params[:course_id].present?
      @posts = @posts.where(course_id: params[:course_id])
    end
  end

  def show
  end

  def new
    @post = Post.new
    @courses = Course.all
  end

  def edit
    @courses = Course.all
  end

  def create
    @post = current_user.posts.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: "Post was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_post
    @post = Post.find(params.require(:id))
  end

  def post_params
    params.require(:post).permit(:title, :body, :course_id)
  end

  def authorize_owner!
    return if @post.user == current_user

    redirect_to posts_path, alert: "You are not allowed to modify this post."
  end

end