class PageClassifier::Parser
  Dir[File.join(File.dirname(__FILE__), "parsers", "*.rb")].each do |f|
    PageClassifier::Parsers.const_get(File.basename(f,'.rb').classify)
  end

  attr_reader :media_type, :media_guid

  def match?(*)
    raise MatchMethodNotDefinedError
  end

  def call(*)
    raise CallMethodNotDefinedError
  end
end
