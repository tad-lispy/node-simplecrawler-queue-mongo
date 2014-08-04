mongoose = require "mongoose"

item = new mongoose.Schema
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

  # TODO: Other properties of Item (like stats, error description...)

item.virtual 'url'
  .get -> @protocol + '://' + @host + (if @port then ':' + @port) + @path

module.exports = mongoose.model 'QueueItem', item
