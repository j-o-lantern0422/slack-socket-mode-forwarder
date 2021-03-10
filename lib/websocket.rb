
require 'json'
require 'faraday'
require 'openssl'

def version
  'v0'
end

def timestamp
  Time.now.to_i
end

def signing_secret
  ENV["SLACK_SIGNING_SECRET"]
end

def socket_mode_connection_open_url
  "https://slack.com/api/apps.connections.open"
end

def socket_mode_app_token
  ENV["SLACK_SOCKET_MODE_APP_TOKEN"]
end

def local_server_url
  ENV["LOCAL_BOT_SERVER_URL"]
end

def websocket_url
  conn =  Faraday.new(url: socket_mode_connection_open_url) do |f|
    f.request :url_encoded
    f.adapter Faraday.default_adapter
  end

  response = conn.post do |req|
    req.headers['Content-type'] = "application/x-www-form-urlencoded",
    req.headers['Authorization'] = "Bearer #{socket_mode_app_token}"
  end

  socket_url = JSON.parse(response.body)["url"]
end

def local_server
  Faraday.new(url: local_server_url) do | f |
    f.request :url_encoded
    f.adapter Faraday.default_adapter
  end
end

