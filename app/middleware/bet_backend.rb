require 'faye/websocket'

class BetBackend

  def initialize(app)
    @app     = app
    @clients = []
  end

  def call(env)
    if Faye::WebSocket.websocket?(env)
      ws = Faye::WebSocket.new(env, nil, { ping: 15 })

      ws.on :open do |event|
        @clients << ws
      end

      ws.on :message do |event|
        @clients.each { |c| c.send(event.data) }
      end

      ws.on :close do |event|
        @clients.delete(ws)
        ws = nil
      end

      ws.rack_response
    else
      @app.call(env)
    end
  end

end