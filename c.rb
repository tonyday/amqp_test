#!/usr/bin/env ruby
require 'mq'

AMQP.start(:host => "localhost") do
  q = MQ.new.queue('events')
  q.subscribe do |msg|
    puts msg
  end
end
