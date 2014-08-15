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
crawler.name  = 'default';
crawler.queue = new Queue(
  mongoose.connections[0],
  crawler
);

```

# Contributing

Much welcome :)
