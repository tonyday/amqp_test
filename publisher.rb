#!/usr/bin/env ruby

require 'mq'

AMQP.start do

# All queues are created automatically the first time it is
# accessed. Make sure this is the same queue our consumers
# will use.
#  qname = Time.now.strftime('%Y%m%d%H%M%S')
  qname = 'qname'
  q = MQ.queue(qname, :durable => true)

  i=0
  while i < 1000
    i += 1
    d = "Hello, World #{qname} - #{i}"
    p d
    q.publish(d, :persistent => true)
  end

  AMQP.stop{ EM.stop }

end
