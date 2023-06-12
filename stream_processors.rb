module StreamProcessors
  def test_stream_processor
    Proc.new do |personality_test, ready|
      @personality_test = parse_text_to_json(personality_test)
      @ready = ready
      settings.sockets.each{|s| s.send(erb :personality_test) }
    end
  end

  def evaluation_stream_processor
    Proc.new do |evaluation|
      @evaluation = Kramdown::Document.new(evaluation).to_html
      settings.sockets.each{|s| s.send(erb :evaluation) }
    end
  end

  def parse_text_to_json(text)
    {}
  end
end
