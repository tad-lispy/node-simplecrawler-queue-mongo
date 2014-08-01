# TODO: We assume that there is a connection to mongo established by crawler app


mongoose = require "mongoose"
Item     = require "./QueueItem"

module.exports = class MongoQueue
  constructor: (mongouri) ->
    mongoose.connect mongouri
    mongoose.connection.once 'connected', =>
      console.log "Mongo queue connected"

  length: 0 # Temporary solution until simplecrawler core starts using async method for queue length

  # Add item to queue
  add: (protocol, host, port, path, callback) ->
    data = {
      protocol
      host
      port
      path
    }
    @length++
    Item.findOne data, (error, item) ->
      if item
        item.set data
      else
        item = new Item data

      item.save callback

  # Check if an item already exists in the queue...
  exists: (protocol, domain, port, path, callback) ->
    data = {
      protocol
      domain
      port
      path
    }
    Item.count data, callback

  # Get last item in queue...
  last = (callback) ->
    Item
      .findOne
      .sort id: -1
      .exec callback

  # Get item from queue
  get: Item.findById

  # Get first unfetched item in the queue (and return its index)
  oldestUnfetchedItem: (callback) ->
    Item
      .findOne fetched: no
      .exec callback

  # Gets the maximum total request time, request latency, or download time
  max: (statisticName, callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the minimum total request time, request latency, or download time
  min: (statisticName,callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the minimum total request time, request latency, or download time
  avg: (statisticName,callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the number of requests which have been completed.
  complete: (callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the number of queue items with the given status
  countWithStatus: (status, callback) ->
    Item.count {status}, callback

  # Gets the number of queue items with the given status
  getWithStatus: (status, callback) ->
    Item.find {status}, callback

  # Gets the number of requests which have failed for some reason
  errors: (callback) ->
    Item.count status: 'error', callback

  # Writes the queue to disk
  freeze: (filename, callback) ->
    # TODO: Later. The queue is backed by MongoDB, so freeze has low priority
    process.nextTick -> callback null

  # Reads the queue from disk
  defrost: (filename, callback) ->
    # TODO: Later. The queue is backed by MongoDB, so defrost has low priority
    process.nextTick -> callback null
