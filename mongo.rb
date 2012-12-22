require 'benchmark'
require 'json'

def mongo_benchmark(data,offset)
	require 'mongo'
	mongo_client = Mongo::MongoClient.new("localhost", 27017)
	mongo_client.drop_database("mydb")
	db = mongo_client.db("mydb")
	coll = db["testCollection"]
	db["testCollection"].ensure_index([["friends.id", Mongo::ASCENDING]])

	(1..100000).each do |counter|
  		data['_id'] = (data['id'].to_i + counter + offset).to_s
  		coll.insert(data)
	end
end

contents = File.read('data.json')
data = JSON.parse(contents)
offset = 0
offset = ARGV[0].to_i if !ARGV[0].nil?

Benchmark.bm do |x|

  x.report("mongodb:") { mongo_benchmark(data,offset) }

end
