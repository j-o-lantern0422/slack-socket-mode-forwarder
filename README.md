## Slack Socket Mode Forwarder

Slackに実装されたSocket ModeをRubyで使えるようにならないかと実験したもの。[slack\-ruby/slack\-ruby\-bot\-server\-events\-sample: Sample for slack\-ruby\-bot\-server\-events\.](https://github.com/slack-ruby/slack-ruby-bot-server-events-sample) のようにEvent APIを利用するタイプのSlack Botのサーバに、Socket Modeの利用時に発行されるWebSocketからの通信を転送する。
実験用途で作ったものなので、あらゆるEvent APIのリクエストが適切に転送されているかは確認していない。
