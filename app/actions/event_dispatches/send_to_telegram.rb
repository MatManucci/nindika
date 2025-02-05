# frozen_string_literal: true

module EventDispatches
  class SendToTelegram < Actor
    input :client, type: TelegramClient, default: -> { TelegramClient.new }

    def call
      pending_dispatches_grouped_by_item_id.each_with_index do |(_item_id, dispatches), index|
        send_message(dispatches, index)
        sleep 1
      rescue StandardError => e
        raise e if Rails.env.development?

        Sentry.capture_exception(e, extra: { dispatches: dispatches })
      end
    end

    private

    def pending_dispatches_grouped_by_item_id
      EventDispatch
        .pending
        .telegram
        .joins(:item_event)
        .includes(:item_event)
        .order('item_events.event_type')
        .group_by { |d| d.item_event.item_id }
    end

    def send_message(dispatches, index)
      text = build_text(dispatches)
      response = client.send_message(chat_id: '@nindika_com', bot_token: bot_token(index), text: text)

      if response['ok']
        EventDispatch.where(id: dispatches.pluck(:id)).update_all(sent_at: Time.zone.now)
      else
        Sentry.capture_message('Cannot send telegram notifications', extra: response)
      end
    end

    def build_text(dispatches)
      dispatches.map { |d| TelegramEventTextBuilder.build(item_event: d.item_event) }.join("\n\n")
    end

    def bot_token(index)
      bot_tokens[index % 3]
    end

    def bot_tokens
      @bot_tokens ||= Rails.application.credentials.telegram_bots
    end
  end
end
