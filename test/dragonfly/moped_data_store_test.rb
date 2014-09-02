require 'test_helper'
require 'dragonfly/moped_data_store'
require 'dragonfly/serializer'

describe Dragonfly::MopedDataStore do

  include Dragonfly::Serializer

  # ---------------------------------------------------------------------

  let(:app) { Dragonfly.app }
  let(:content) { Dragonfly::Content.new(app, "Foo Bar!") }
  let(:data_store) { Dragonfly::MopedDataStore.new(host: ENV["MOPED-DATA-STORE-TEST-HOST"], port: ENV["MOPED-DATA-STORE-TEST-PORT"], db: ENV["MOPED-DATA-STORE-TEST-DB"]) }
  let(:meta) { { my_meta: 'my meta' } }

  let(:session) { moped_session }
  let(:bucket) { session.bucket }

  # ---------------------------------------------------------------------

  describe '#write' do
    it "stores the data in the database" do
      uid = data_store.write(content)

      response = bucket.open(uid, 'r')
      response.read.must_equal content.data
    end

    it 'stores default mime type' do
      uid = data_store.write(content)

      response = bucket.open(uid, 'r')
      response.content_type.must_equal 'application/octet-stream'
    end

    it 'stores supplied mime type' do
      uid = data_store.write(content, content_type: 'text/plain')
      
      response = bucket.open(uid, 'r')
      response.content_type.must_equal 'text/plain'
    end

    it 'stores additional meta data' do
      uid = data_store.write(content, meta: meta)

      response = bucket.open(uid, 'r')
      response.metadata[:my_meta].must_equal meta[:my_meta]
    end
  end

  # ---------------------------------------------------------------------

  describe '#read' do
    before do
      @file = bucket.open(BSON::ObjectId.new, "w+")
      @file.metadata = meta
      @file.write(content.data)

      @result = data_store.read(@file._id)
    end

    it 'retrieves the file' do
      @result.first.must_equal content.data
    end

    it 'retrieves meta data' do
      @result.last.must_equal meta
    end

    it 'raises DataNotFound when file does not exist' do
      proc { data_store.read(BSON::ObjectId.new) }.must_raise Dragonfly::MopedDataStore::DataNotFound
    end
  end

  # ---------------------------------------------------------------------

  describe '#destroy' do
    before do
      @file = bucket.open(BSON::ObjectId.new, "w+")
      @file.metadata = meta
      @file.write(content.data)
    end

    it 'destroys data in the database' do
      res = data_store.destroy(@file._id)
      res.must_equal true
      proc { bucket.open(@file._id, 'r') }.must_raise RuntimeError
    end
  end

  # ---------------------------------------------------------------------

end