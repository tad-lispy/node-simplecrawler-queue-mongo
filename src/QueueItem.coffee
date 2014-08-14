QueueItem = undefined

module.exports = (connection, crawler) ->
  schema = new connection.base.Schema
    protocol:
      type    : String
      required: yes

    host    :
      type    : String
      required: yes

    port    :
      type    : Number

    path    :
      type    : String
      required: yes

    status  :
      type    : String
      default : 'queued'

    fetched :
      type    : Boolean
      default : no

    stateData:
      type    : Object
      default : {}

    crawler :
      # Identifies crawler, for which this queue is held
      # TODO: It would be nice to use discriminators instead, see below
      type    : String
      required: yes
      indexed : yes
      default : 'default'

    # TODO: Other properties of Item (like stats, error description...)

  schema.virtual 'url'
    .get -> @protocol + '://' + @host + (if @port then ':' + @port) + @path

  # TODO: It would be nice to use discriminators instead.
  # It throws Discriminator "#{name}" can only be a discriminator of the root model
  # WTF?
  QueueItem ?= connection.model "QueueItem", schema
  # Item.schema.path 'crawler',
  #   type    : String
  #   required: yes
  #   indexed : yes
  #   default : crawler

  module.exports = QueueItem
