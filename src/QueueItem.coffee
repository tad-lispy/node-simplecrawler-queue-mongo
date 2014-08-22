QueueItem = undefined

module.exports = (connection, crawler) ->
  schema = new connection.base.Schema
    protocol:
      type    : String
      required: yes
      index   : yes

    host    :
      type    : String
      required: yes
      index   : yes

    port    :
      type    : Number
      index   : yes

    path    :
      type    : String
      required: yes
      index   : yes

    status  :
      type    : String
      default : 'queued'
      index   : yes
      enum    : [
        'queued'      # Added to queue
        'spooled'     # Requested, but no response yet
        'fetched'     # Normal response (OK) received. This item is done.
        'redirected'  # 30x Redirect received. Target should probabily be added to queue, but it's up to application logic to handle this.
        'error'       # Some kind of error. Details should go to stateData
      ]

    fetched :
      # TODO: Isn't it redundant? We have status field for that.
      type    : Boolean
      default : no

    stateData:
      # Other properties of Item (like stats, error description)
      type    : Object
      default : {}

    crawler :
      # Identifies crawler, for which this queue is held
      # TODO: It would be nice to use discriminators instead.
      # It throws Discriminator "#{name}" can only be a discriminator of the root model
      # WTF?
      type    : String
      index   : yes
      default : 'default'

  # Compound index for findAndModify query run in MongoQueue#oldestUnfetchedItem
  # Without it mongod produces gigabytes of logs with warnings
  schema.index
    crawler: 1
    status : 1

  schema.virtual 'url'
    .get -> @protocol + '://' + @host + (if @port then ':' + @port) + @path

  QueueItem ?= connection.model "QueueItem", schema
  module.exports = QueueItem
