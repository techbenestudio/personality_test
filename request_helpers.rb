module ReqquestHelpers
  def uri
    @openapi_uri ||= URI('https://api.openai.com/v1/chat/completions')
  end

  def connection
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 120
    http
  end

  def request_body
    {
      'model' => 'gpt-3.5-turbo',
      'messages' => settings.messages,
      'max_tokens' => 1000,
      'temperature' => 0.8
    }
  end

  def http_request(options={})
    req = Net::HTTP::Post.new(uri.path,
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{ENV['OPENAI_API_TOKEN']}"
      }
    )

    req.body = request_body.merge(options).to_json

    req
  end

  def stream_openai(stream_processor)
    stream_request = http_request('stream' => true)

    logger.info 'Sending streaming request to openai API'
    logger.info stream_request.body

    response_text = []

    connection.request(stream_request) do |response|
      response.read_body do |chunk|
        logger.info chunk

        chunk.split("\n").each do |data|
          next if data.strip.empty?

          content = data.split('data:').last.strip
          if content != '[DONE]'
            json_content = JSON.parse(content)
            response_text.push(json_content.dig('choices', 0, 'delta', 'content'))

            stream_processor.call response_text.join, false
          end
        end
      end
    end

    content = response_text.join

    store_message('assistant', content)

    stream_processor.call content, true
  rescue => e
    logger.error e.inspect
    settings.sockets.each{|s| s.send(erb :error) }
  ensure
    logger.info 'Received streamed response from openai API'
    logger.info "#{response_text.count} tokens"
    logger.info response_text.join
  end

  def openai_response
    openai_request = http_request

    logger.info 'Sending request to openai API'
    logger.info openai_request.body

    response = connection.request(openai_request)

    logger.info 'Received response from openai API'
    logger.info response.body

    json_response = JSON.parse(response.body)

    content = json_response.dig('choices', 0, 'message', 'content').strip

    store_message('assistant', content)

    content
  rescue => e
    logger.error e.inspect
    settings.sockets.each{|s| s.send(erb :error) }
  end
end
