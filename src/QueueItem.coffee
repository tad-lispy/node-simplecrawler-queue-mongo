mongoose = require "mongoose"

item = new mongoose.Schema
  protocol:
    type    : String
    required: yes

  domain  :
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

  # TODO: Other properties of Item (like stats, error description...)

item.virtuals.url = @protocol + '://' + @domain + (if @port then ':' + @port) + @path

module.exports = mongoose.model 'QueueItem', item
