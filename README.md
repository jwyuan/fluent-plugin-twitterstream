# Twitter stream input plugin for fluentd

A fluentd input plugin which takes input from from the [Twitter streaming APIs]

## Install

Currently, the easiest way to run it is to move the in_twitterstream.rb file into your fluentd plugin directory.
Gem packaging will be done in the future.

## Usage

### Configuration
Please add the following configurations to fluent.conf

    ## twitterstream input
    <source>
    type twitterstream
    consumer_key ...          # required
    consumer_secret ...       # required
    access_token_key ...      # required
    access_token_secret ...   # required
    tag twitter.sample        # optional (defaults to twitterstream.test)

    ## at most one of the following three lines is required (if none, uses sample stream)
    ## Reference: https://dev.twitter.com/docs/api/1.1/post/statuses/filter
    locations -122.75,36.8,-121.75,37.8     # location: san francisco
    track ruby,python                       # keywords
    follow 1224242142,12412412442           # user ids (not screen names)
    </source>

### TODO
* Gem packaging
* Tests
* According to Twitter's API documentation, all three paramters (locations, track, and follow) should be allowed in
a filter query.  But currently, the Tweetstream gem does not seem to fully support this.  Investigation is needed.

[Twitter streaming APIs]: https://dev.twitter.com/docs/streaming-apis

