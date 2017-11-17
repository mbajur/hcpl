class PageClassifier::Perform
  attr_reader :page

  def parsers
    PageClassifier::Parser
      .descendants
      .reject { |p| p == PageClassifier::Parsers::None }
      .map(&:new)
      .push(PageClassifier::Parsers::None.new)
  end

  def parser_for_input(input)
    parsers.find { |parser| parser.match?(input) }
  end

  def initialize(page)
    @page = page
  end

  def call
    parser = parser_for_input(page)
    parser.call

    parser
  end
end
