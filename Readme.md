Mongo powered queue for [SimpleCrawler](https://github.com/cgiffard/node-simplecrawler/)

**NOTE**: This code is very early in developmnt. Please try it and let everybody know what you think (and what bugs have you found) via GitHub issues and pull requests.

# Install

It's still *alpha* quality software, so I haven't pushed it to NPM yet. Please install it from GitHub repo.

```shell
git clone https://github.com/lzrski/node-simplecrawler-queue-mongo.git ./simplecrawler-queue-mongo
cd simplecrawler-queue-mongo
npm install
npm run-script prepublish
```

There is also `npm run-script develop` to watch and rebuild - please try it if you would like to hack on this code.

# Use

```coffee-script
Crawler  = require "simplecrawler"
Queue    = require "./simplecrawler-queue-mongo"
mongoose = require "mongoose"

mongoose.connect "localhost/test"

crawler       = Crawler.crawl "http://radzimy.co/"
crawler.name  = 'default'
crawler.queue = new Queue mongoose.connections[0], crawler
do crawler.start
```
which compiles to:

```java-script
var Crawler, Queue, crawler, mongoose;

Crawler   = require("simplecrawler");
Queue     = require("./simplecrawler-queue-mongo");
mongoose  = require("mongoose");

mongoose.connect("localhost/test");

crawler       = Crawler.crawl("http://radzimy.co/");
crawler.name  = 'radzimy.co';
crawler.queue = new Queue(
  mongoose.connections[0],
  crawler
);

```

# Notes

ATM it relies on Mongoose connection that application provide. In the future I'd like to decouple it, so that application could provide native MongoDB connection or connection string.

If you want to use multiple crawlers with one database (eg. for crawling multiple domains) set unique name property on each crawler (like in the example). It will be used to distinguish queues in a collection.

# Contributing

Much welcome :)
