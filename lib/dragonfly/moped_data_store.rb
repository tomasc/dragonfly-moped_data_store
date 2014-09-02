require 'dragonfly/moped_data_store/version'
require 'dragonfly'
require 'moped'
require 'moped/gridfs'

module Dragonfly
  class MopedDataStore

    class DataNotFound < StandardError; end

    # ---------------------------------------------------------------------

    include Serializer

    # ---------------------------------------------------------------------

    OBJECT_ID = BSON::ObjectId
    INVALID_OBJECT_ID = Moped::Errors::InvalidObjectId

    # =====================================================================

    def initialize opts={}
      @host = opts[:host] || '127.0.0.1'
      @port = opts[:port] || '27017'
      @db = opts[:db]
    end

    def session
      @session ||= Moped::Session.new(["#{@host}:#{@port}"]).tap do |session|
        session.use @db
      end
    end

    # ---------------------------------------------------------------------
    
    def write temp_object, opts={}
      content_type = opts[:content_type] || opts[:mime_type] || 'application/octet-stream'
      meta = temp_object.meta
      meta = meta.merge(opts[:meta]) if opts[:meta]

      grid_file = session.bucket.open(BSON::ObjectId.new, "w+")
      grid_file.content_type = content_type
      grid_file.metadata = meta
      grid_file.write(temp_object.data)
      grid_file._id
    end

    # ---------------------------------------------------------------------

    def read uid
      grid_file = session.bucket.open(uid, 'r')
      meta = grid_file.metadata.each_with_object({}){ |(k,v), h| h[k.to_sym] = v }
      [ grid_file.read, meta ]

    rescue RuntimeError
      raise DataNotFound
    end

    # ---------------------------------------------------------------------

    def destroy uid
      session.bucket.delete(uid)
    end

    # ---------------------------------------------------------------------

  end
end

Dragonfly::App.register_datastore(:moped){ Dragonfly::MopedDataStore }
