require 'benchmark'
require 'json'

def redis_benchmark(data,offset)
  require "redis"
  require "hiredis"
  redis = Redis.new(:driver => :hiredis)
  friends = data['friends']
  data.delete('friends')
  user = data.to_json
  friend_json = friends[0].to_json


  (1..100000).each do |counter|
     redis.pipelined do
     parent_id = data['id'].to_i + counter + offset
     friends_ids = friends.collect { |friend| friend['id']}
      redis.set("user:#{parent_id}", user)
      redis.sadd("user:#{parent_id}:friends",friends_ids)
     end
  end

end


contents = File.read('data.json')

data = JSON.parse(contents)
offset = 0
offset = ARGV[0].to_i if !ARGV[0].nil?


Benchmark.bm do |x|

  x.report("redis:") { redis_benchmark(data,offset) }

end


