#!/usr/bin/env ruby

require 'mq'

Signal.trap('INT') { AMQP.stop{ EM.stop } }
Signal.trap('TERM'){ AMQP.stop{ EM.stop } }

$stdout.sync = true

foo = 'foo'

File.delete(foo) if File.exist?(foo)

AMQP.start do
  q = MQ.queue('qname')

  n = 0
  q.subscribe do |msg|
    n += 1
    print "#{n} "
    File.open(foo, 'a') { |file| file.puts "#{n}: #{msg}" } if msg
  end

end

puts 'All done - for now !!'
