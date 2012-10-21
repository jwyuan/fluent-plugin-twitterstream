var config = require('./config.js');
var twitter = require('ntwitter'),
    logger = require('fluent-logger');

/**
 * Arguments:
 * 0: tag - required
 * 1: keyword - if not defined then listen to sample stream
 */
 // Note: first 2 elements in argv is always node and then filename
 // so first argument we want is index 2
if (process.argv.length < 3) {
  console.log("Not enough arguments: node server.js [tag] [keywords](optional)");
  process.exit(1);
}

var twit = new twitter({
    consumer_key: config.consumer_key,
    consumer_secret: config.consumer_secret,
    access_token_key: config.access_token_key,
    access_token_secret: config.access_token_secret
});

logger.configure('twitter', {
   host: 'localhost',
   port: 24224,
   timeout: 3.0
});

var tag = process.argv[2];
var keywords = process.argv.length > 3 ? process.argv[3] : null;

// flatten structure and only propagate only selected properties
var filterMessage = function(data) {
  var message = {
    created_at: data.created_at,
    user_screen_name: data.user.screen_name,
    user_name: data.user.name,
    text: data.text,
    retweet_count: data.retweet_count
  };
  if (data.retweeted_status) {
    message.rt_created_at = data.retweeted_status.created_at;
    message.rt_user_screen_name = data.retweeted_status.user.screen_name;
    message.rt_user_name = data.retweeted_status.user.name;
    message.rt_text = data.retweeted_status.text;
    message.rt_retweet_count = data.retweeted_status.retweet_count;
  }
  return message;
};

if (keywords) {
  // using the filter api 
  // see here for paramters: https://dev.twitter.com/docs/api/1.1/post/statuses/filter)
  twit.stream('statuses/filter', {'track':keywords}, function(stream) {
    stream.on('data', function(data) {
      logger.emit(tag, filterMessage(data));
    });
  });
} else {
  // Using the sample api
  twit.stream('statuses/sample', function(stream) {
      stream.on('data', function(data) {
        logger.emit('sample', filterMessage(data));
      });
  });
}


