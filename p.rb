#!/usr/bin/env ruby
require 'mq'

AMQP.start(:host => 'localhost') do
  MQ.queue('events').publish("hello world")
  MQ.queue('events').publish("it is #{Time.now}")
  AMQP.stop { EM.stop }
end
