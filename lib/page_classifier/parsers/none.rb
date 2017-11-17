class PageClassifier::Parsers::None < PageClassifier::Parser
  def match?(page)
    true
  end

  def call
    @media_type = nil
  end
end
