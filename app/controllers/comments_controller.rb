class CommentsController < ApplicationController
  before_action :authenticate!
  before_action :set_post, only: %i[ index create new ]
  before_action :set_comment, only: %i[ show edit update destroy ]

  # GET /comments
  def index
    @comments = @post.comments.order(created_at: :desc)
  end

  # GET /comments/1
  def show
  end

  # GET /comments/new
  def new
    @comment = @post.comments.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to @comment.post, notice: "Comment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to post_path(@comment.post, anchor: dom_id(@comment)), notice: "Comment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
    redirect_to comments_url, notice: "Comment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:post_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:body).merge(user_id: Current.user.id)
    end
end
