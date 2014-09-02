require 'bundler/setup'
require 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'dragonfly/moped_data_store'
require 'moped'
require 'moped/gridfs'
require 'rubygems'
require 'database_cleaner'

if ENV["CI"]
  require "coveralls"
  Coveralls.wear!
end

ENV["MOPED-DATA-STORE-TEST-HOST"] ||= "127.0.0.1"
ENV["MOPED-DATA-STORE-TEST-PORT"] ||= "27017"
ENV["MOPED-DATA-STORE-TEST-DB"]   ||= "dragonfly-moped-datastore-test"

def moped_session
  addr = ENV["MOPED-DATA-STORE-TEST-HOST"] + ":" + ENV["MOPED-DATA-STORE-TEST-PORT"]
  session = Moped::Session.new([addr])
  session.use(ENV["MOPED-DATA-STORE-TEST-DB"])
  session
end

def drop_all_collections
  moped_session.collections.each(&:drop)
end

class MiniTest::Spec
  before(:each) { drop_all_collections }
  after(:all) { drop_all_collections }
end
