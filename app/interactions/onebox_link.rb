class OneboxLink < ActiveInteraction::Base
  string :link, default: nil

  validates :link, presence: true, url: { message: 'wydaje się być niepoprawny' }

  def execute
    Onebox.preview(link, cache: Rails.cache).to_s
  end
end
