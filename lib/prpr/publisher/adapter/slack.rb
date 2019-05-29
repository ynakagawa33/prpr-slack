require 'slack-notifier'

module Prpr
  module Publisher
    module Adapter
      class Slack < Base
        def publish(message)
          params = { link_names: true }

          if message.from
            params[:username] = message.from.login
            params[:icon_url] = message.from.avatar_url
          end

          if message.room
            params[:channel] = message.room
          end

          notifier.ping message.body, params
        end

        private

        def notifier
          @notifier ||= ::Slack::Notifier.new webhook_url do
            middleware format_message: { formats: [] },
                       format_attachments: { formats: [] }
          end
        end

        def webhook_url
          Prpr::Config::Env.default[:slack_webhook_url]
        end
      end
    end
  end
end
