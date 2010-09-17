#!/usr/bin/env ruby

require 'mq'

AMQP.start do

# All queues are created automatically the first time it is
# accessed. Make sure this is the same queue our consumers
# will use.
#  qname = Time.now.strftime('%Y%m%d%H%M%S')
  exchange_name = 'td_exchange'
  queue_name = 'td_queue'
  exchange = MQ.direct(exchange_name, :durable => true)
  MQ.queue(queue_name, :durable => true).bind(exchange_name)

  i=0
  while i < 1000
    i += 1
    d = "Hello, World #{exchange_name} - #{i}"
    p d
    exchange.publish(d, :persistent => true)
  end

  AMQP.stop{ EM.stop }

end
