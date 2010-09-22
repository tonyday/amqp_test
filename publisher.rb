#!/usr/bin/env ruby
require 'mq'

AMQP.start do
  exchange_name = 'td_exchange'
  queue_name = 'td_queue'
  exchange = MQ.direct(exchange_name, :durable => true)
  MQ.queue(queue_name, :durable => true).bind(exchange_name)
  (1..1000).each do |n|
    d = "Hello, World - #{n}"
    exchange.publish(d, :persistent => true)
  end
  AMQP.stop { EM.stop }
end
puts 'Done !'
