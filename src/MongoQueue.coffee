# TODO: We assume that there is a connection to mongo established by crawler app

_        = require "lodash"
getItem  = require "./QueueItem"

module.exports = class MongoQueue
  constructor: (mongo, @crawler) ->
    console.log "Initializing mongo queue for #{@crawler.name}"
    @Item = getItem mongo, @crawler.name

    # Update status of items in db on crawler events
    @updateStatus = (item, status) ->
      console.log "#{status} \t #{item.url}"
      # query = _.pick item, [
      #   'protocol'
      #   'host'
      #   'path'
      #   'port'
      # ]
      item.set {status}
      item.save (error) ->
        if error then throw error

    eventstates =
      fetchstart   : 'spooled'
      fetchcomplete: 'fetched'
      fetcherror   : 'error'

    setEventHandler = (event, status) =>
      @crawler.on event, (item) =>
        @updateStatus item, status

    setEventHandler event, status for event, status of eventstates


  # Add item to queue
  add: (protocol, host, port, path, callback) ->
    data = {
      protocol
      host
      port
      path
      crawler: @crawler.name
    }
    @Item.findOne data, (error, item) =>
      if item
        item.set data
      else
        item = new @Item data

      item.save callback

  # Check if an item already exists in the queue...
  exists: (protocol, domain, port, path, callback) ->
    data = {
      protocol
      domain
      port
      path
      crawler: @crawler.name
    }
    @Item.count data, callback

  getLength: (callback) ->
    @Item.count callback

  # Get last item in queue...
  last: (callback) ->
    @Item
      .findOne crawler: @crawler.name
      .sort id: -1
      .exec callback

  # Get item from queue
  get: (id, callback) ->
    @Item.findById id, callback

  # Get first unfetched item in the queue (and return its index)
  oldestUnfetchedItem: (callback) ->
    @Item
      .findOne
        crawler: @crawler.name
        fetched: no
      .exec callback

  # Gets the maximum total request time, request latency, or download time
  max: (statisticname, callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the minimum total request time, request latency, or download time
  min: (statisticname, callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the minimum total request time, request latency, or download time
  avg: (statisticname, callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the number of requests which have been completed.
  complete: (callback) ->
    # TODO: Later. Statistics require additional fields in model.
    process.nextTick -> callback null, 0

  # Gets the number of queue items with the given status
  countWithStatus: (status, callback) ->
    @Item.count {
      status
      crawler: @crawler.name
    }

  # Gets the number of queue items with the given status
  getWithStatus: (status, callback) ->
    @Item.find {
      status
      crawler: @crawler.name
    }, callback

  # Gets the number of requests which have failed for some reason
  errors: (callback) ->
    @Item.count
      status: 'error'
      crawler: @crawler.name
      callback

  # Writes the queue to disk
  freeze: (filename, callback) ->
    # TODO: Later. The queue is backed by MongoDB, so freeze has low priority
    process.nextTick -> callback null

  # Reads the queue from disk
  defrost: (filename, callback) ->
    # TODO: Later. The queue is backed by MongoDB, so defrost has low priority
    process.nextTick -> callback null
