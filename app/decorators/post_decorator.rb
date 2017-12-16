class PostDecorator < Draper::Decorator
  delegate_all

  def href
    object.link.present? ? object.link : object.path
  end
end
