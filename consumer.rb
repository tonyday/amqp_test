#!/usr/bin/env ruby

require 'mq'

#Signal.trap('INT') { AMQP.stop { EM.stop } }
#Signal.trap('TERM') { AMQP.stop { EM.stop } }

$stdout.sync = true

foo = 'foo'

#File.delete(foo) if File.exist?(foo)

AMQP.start do
  q = MQ.queue('td_queue')

  MQ.prefetch(1)

  n = 0
  q.subscribe(:ack => true) do |header, body|
#  q.subscribe() do |msg|
    n += 1
    print "#{n} "
#    File.open(foo, 'a') { |file| file.puts "#{n}: #{body}" } if body
    puts "#{n}: #{body}" if body
    # If we do not ack the message it will not be purged from the queue
    # blah blah blah
    header.ack
    if n == 10
      puts 'That is enough for now'
      q.unsubscribe
      AMQP.stop do
        EM.stop
      end
    end
    sleep rand * 3
  end

end

puts 'All done - for now !!'
