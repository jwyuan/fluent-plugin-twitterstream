# Twitter stream input plugin for fluentd

A fluentd input plugin which takes input from from the [Twitter streaming APIs]

## Install

Currently, the easiest way to run it is to move the in_twitterstream.rb file into your fluentd plugin directory.
Gem packaging will be done in the future.

## Usage

### Configuration
Please add the following configurations to fluent.conf
    # twitterstream input
    <source>
    type twitterstream
    ## required (fill in your api keys)
    consumer_key ...
    consumer_secret ...
    access_token_key ...
    access_token_secret ...

    ## optional (defaults to twitterstream.test)
    tag twitter.sample

    ## at most one of the following three lines is required
    ## if none of these are present, will consume the sample stream
    ## Reference: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
    # locations -122.75,36.8,-121.75,37.8,-74,40,-73,41
    # track ruby,python
    # follow 1224242142,12412412442

### TODO

Befre using [log4js] support, you should install it IN YOUR APPLICATION.
* A problem still exists with buffered output plugins (such as fluentd-plugin-td)
* Gem packaging

[Twitter streaming APIs]: https://dev.twitter.com/docs/streaming-apis

