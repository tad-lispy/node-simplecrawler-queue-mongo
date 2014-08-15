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
crawler.name  = 'radzimy-co' # You don't need this if you only run one crawler.
crawler.queue = new Queue mongoose.connections[0], crawler
```
which compiles to:

```javascript
var Crawler, Queue, crawler, mongoose;

Crawler   = require("simplecrawler");
Queue     = require("./simplecrawler-queue-mongo");
mongoose  = require("mongoose");

mongoose.connect("localhost/test");

crawler       = Crawler.crawl("http://radzimy.co/");
crawler.name  = 'radzimy-co';
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

# Licence (GPL 3)

Copyright (C) 2014  Tadeusz Łazurski

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.
