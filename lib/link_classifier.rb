module LinkClassifier

  class MatchMethodNotDefinedError < ArgumentError; end
  class CallMethodNotDefinedError < ArgumentError; end

  class Perform
    attr_reader :page

    def parsers
      LinkClassifier::Parser.descendants
        .reject { |p| p == LinkClassifier::Parsers::None }
        .map(&:new)
        .push(LinkClassifier::Parsers::None.new)
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

  module Parsers; end

  class Parser
    attr_reader :media_type, :media_guid

    def match?(*)
      raise MatchMethodNotDefinedError
    end

    def call(*)
      raise CallMethodNotDefinedError
    end
  end

  class Parsers::FacebookEvent < Parser
    def match?(page)
      page.url =~ /facebook\.com\/events/
    end

    def call
      @media_type = :facebook_event
    end
  end

  class Parsers::BandcampProfile < Parser
    def match?(page)
      page.url =~ /bandcamp\.com/
    end

    def call
      @media_type = :basecamp_profile
    end
  end

  class Parsers::None < Parser
    def match?(page)
      true
    end

    def call
      @media_type = nil
    end
  end

end
