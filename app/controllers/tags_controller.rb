class TagsController < ApplicationController

  layout 'with_sidebar'

  def show
    @tag = ActsAsTaggableOn::Tag.find_by(slug: params[:slug])

    @posts = Post.tagged_with(@tag.name).page(params[:page])
  end

end
