# Twitter stream input into fluentd

Ouputs twitter stream into fluentd.  This is a simple mashup which uses [ntwitter] and [fluent-logger-node]

## Install

Run the following in the current directory to install dependencies:

    npm install
    
## Prerequistes

fluentd daemon should listen on TCP port.  See sample-fluent.conf

Edit config.js to fill in your Twitter api keys

## Usage

To start listening to the twitter public stream statuses/sample:

    node server.js [tag] [keywords](optional)

Tag is used to label the stream.  Keywords is an optional comma delimited list of words to filter on.
If not specified will consume from the sample stream.

[fluent-logger-node]: https://github.com/yssk22/fluent-logger-node
[ntwitter]: https://github.com/AvianFlu/ntwitter

