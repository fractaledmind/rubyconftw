class BenchmarkingController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_user_update_last_seen_at

  # POST /benchmarking/read_heavy
  def read_heavy
    act_and_respond(
      post_create:      0.10,
      comment_create:   0.10,
      post_destroy:     0.02,
      comment_destroy:  0.03,
      post_show:        0.25,
      posts_index:      0.25,
      comment_show:     0.25,
    )
  end

  # POST /benchmarking/write_heavy
  def write_heavy
    act_and_respond(
      post_create:      0.25,
      comment_create:   0.25,
      post_destroy:     0.05,
      comment_destroy:  0.20,
      post_show:        0.05,
      posts_index:      0.15,
      comment_show:     0.05,
    )
  end

  # POST /benchmarking/balanced
  def balanced
    act_and_respond(
      post_create:      0.17,
      comment_create:   0.17,
      post_destroy:     0.05,
      comment_destroy:  0.11,
      post_show:        0.17,
      posts_index:      0.17,
      comment_show:     0.16,
    )
  end

  private

    def set_user_update_last_seen_at
      @user = User.where("id >= ?", rand(User.minimum(:id)..User.maximum(:id))).limit(1).first
      @user.update!(last_seen_at: Time.now)
    end

    def post_create
      Post.create!(user: @user, title: "Post #{request.uuid}", description: Faker::Lorem.paragraphs.join("\n"))
    end

    def comment_create
      post = Post.where("id >= ?", rand(Post.minimum(:id)..Post.maximum(:id))).limit(1).first
      Comment.create!(user: @user, post: post, body: "Comment #{request.uuid}")
    end

    def post_destroy
      post = Post.where("id >= ?", rand(Post.minimum(:id)..Post.maximum(:id))).limit(1).first
      post.destroy!
    end

    def comment_destroy
      comment = Comment.where("id >= ?", rand(Comment.minimum(:id)..Comment.maximum(:id))).limit(1).first
      comment.destroy!
    end

    def post_show
      @post = Post.where("id >= ?", rand(Post.minimum(:id)..Post.maximum(:id))).limit(1).first
    end

    def posts_index
      @posts = Post.where("id >= ?", rand(Post.minimum(:id)..Post.maximum(:id))).limit(100)
    end

    def comment_show
      @comment = Comment.where("id >= ?", rand(Comment.minimum(:id)..Comment.maximum(:id))).limit(1).first
    end

    def act_and_respond(actions_with_weighted_distribution)
      action = actions_with_weighted_distribution.max_by { |_, weight| rand ** (1.0 / weight) }.first

      send(action)

      case action
      when :post_create
        head :created
      when :comment_create
        head :created
      when :comment_destroy
        head :no_content
      when :post_show
        render "posts/show", status: :ok
      when :posts_index
        render "posts/index", status: :ok
      when :comment_show
        render "comments/show", status: :ok
      end
    end
end
