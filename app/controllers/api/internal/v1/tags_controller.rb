class Api::Internal::V1::TagsController < Api::Internal::V1Controller
  def index
    @tags = Tag.all

    @tags = @tags.search(params[:q]) if params[:q].present?

    render json: @tags.to_json(only: [:id, :name, :is_primary])
  end
end
