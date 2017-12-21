class CommentsController < ApplicationController

  layout 'with_sidebar'

  def create
    @post = Post.find(comment_params[:post_id])
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.valid?
      @comment.save
      redirect_to url_for(@post.path, only_path: true), notice: 'Komentarz dodany pomyślnie!'
    else
      render 'posts/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :post_id)
  end

end
