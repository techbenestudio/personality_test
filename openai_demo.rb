require 'sinatra'
require 'sinatra-websocket'
require 'net/http'
require 'json'
require 'kramdown'

require './messages.rb'
require './request_helpers.rb'
require './stream_processors.rb'

use Rack::Logger

set :server, 'thin'
set :sockets, []

set :messages, []

helpers do
  def logger
    request.logger
  end

  def store_message(role, content)
    settings.messages.push(
      {
        'role': role,
        'content': content
      }
    )
  end

  def start_conversation(role, content)
    settings.messages = [
      {
        'role': role,
        'content': content
      }
    ]
  end

  include StreamProcessors
  include ReqquestHelpers
end

get '/ws' do
  request.websocket do |ws|
    ws.onopen do
      logger.info('Websocket connected')
      settings.sockets << ws
    end
    ws.onclose do
      logger.info('Websocket closed')
      settings.sockets.delete(ws)
    end
  end
end

get '/' do
  'Hello World!'
end

get '/recruit' do

end

post '/positions' do
  @industry = params['industry']

  Thread.new do
    store_message('user', Messages.positions(@industry))

    @positions = JSON.parse openai_response
    settings.sockets.each{|s| s.send(erb :positions) }
  end

  erb :loading
end

post '/experience-levels' do
  @industry = params['industry']
  @position = params['position']

  Thread.new do
    store_message('user', Messages.experience_levels(@industry, @position))

    @experience_levels = JSON.parse openai_response
    settings.sockets.each{|s| s.send(erb :experience_levels) }
  end

  erb :loading
end

post '/personality-test' do
  @industry = params['industry']
  @position = params['position']
  @experience_level = params['experience_level']

  Thread.new do
    store_message('user', Messages.personality_test(@industry, @position, @experience_level))

    stream_openai(test_stream_processor)
  end

  erb :loading
end

post '/evaluate' do
  @industry = params['industry']
  @position = params['position']
  @experience_level = params['experience_level']

  @questions = params['questions']

  Thread.new do
    store_message('user', Messages.evaluation(@industry, @position, @experience_level, @questions))

    stream_openai(evaluation_stream_processor)
  end

  erb :loading
end

get '/chat' do
  start_conversation('system', Messages.master_yoda)

  erb :chat
end

post '/chat' do
  @message = params['message']

  store_message('user', @message)
  @role = 'You'

  settings.sockets.each{|s| s.send(erb :message)}

  Thread.new do
    @message = openai_response
    @role = 'Master Yoda'

    settings.sockets.each{|s| s.send(erb :message)}
  end

  erb :chat_form
end
