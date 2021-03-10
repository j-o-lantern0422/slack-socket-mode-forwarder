require 'json'
require 'faye/websocket'

require_relative './lib/websocket.rb'

EM.run do
  ws = Faye::WebSocket::Client.new(websocket_url)

  ws.on :open do
    p [:open]
  end

  ws.on :message do |event|
    data = JSON.parse(event.data)
    p data

    if JSON.parse(event.data)["type"] == "hello"
      puts "connected ws"
    else
      body = JSON.parse(event.data)["payload"].to_json
      digest = OpenSSL::Digest::SHA256.new
      signature_basestring = [version, timestamp, body].join(':')
      hex_hash = OpenSSL::HMAC.hexdigest(digest, signing_secret, signature_basestring)
      signature = [version, hex_hash].join('=')


      local_server.post do |req|
        req.url                               "#{local_server_url}/api/slack/event"
        req.headers['Content-Type']         = 'application/json'
        req.headers['X-Slack-Signature']    = "#{signature}"
        req.headers['X-Slack-Request-Timestamp'] = "#{timestamp}"
        req.body                            = body
      end
    end
  end

  ws.on :close do |event|
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end
