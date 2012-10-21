module Fluent

class TwitterStreamInput < Fluent::Input
  # Register plugin
  Plugin.register_input('twitterstream', self)

  # required auth params
  config_param :consumer_key,         :string
  config_param :consumer_secret,      :string
  config_param :access_token_key,     :string
  config_param :access_token_secret,  :string
  
  # optional params
  config_param :tag,                  :string, :default => 'twitterstream.test'

  # at most one of these can be provided (if none then use the sample stream)
  config_param :follow,               :string, :default => nil 
  config_param :track,                :string, :default => nil
  config_param :locations,            :string, :default => nil

  def initialize
    require 'tweetstream'
    super
  end

  # This method is called before starting.
  # 'conf' is a Hash that includes configuration parameters.
  # If the configuration is invalid, raise Fluent::ConfigError.
  def configure(conf)
    super
    raise Fluent::ConfigError, "Only one of 'follow', 'track', or 'locations' can be specified (except for 'follow' and 'track')" if (@follow && @locations) || (@track && @locations)
    TweetStream.configure do |config|
      config.consumer_key = @consumer_key
      config.consumer_secret = @consumer_secret
      config.oauth_token = @access_token_key
      config.oauth_token_secret = @access_token_secret
      config.auth_method = :oauth
    end
  end

  # This method is called when starting.
  # Open sockets or files and create a thread here.
  def start
    @thread = Thread.new(&method(:run))
  end

  # This method is called when shutting down.
  # Shutdown the thread and close sockets or files here.
  def shutdown
    Thread.kill(@thread)
  end

  def run
    client = TweetStream::Client.new

    if @location
      $log.debug "starting twitterstream: tag:#{@tag} locations:#{@locations}"
      @client.locations(@locations) do |status|
        transform_status(status)
      end
    elsif @track
      $log.debug "starting twitterstream: tag:#{@tag} track:#{@track}"
      client.track(@track) do |status|
        transform_status(status)
      end
    elsif @follow
      $log.debug "starting twitterstream: tag:#{@tag} follow:#{@follow}"
      client.follow(@follow) do |status|
        transform_status(status)
      end
    else
      $log.debug "starting twitterstream: tag:#{@tag} sample"
      client.sample do |status|
        transform_status(status)
      end
    end
  end

  # only pick out necessary properties in object to store
  def transform_status(status)
    record = {
      'created_at' => status.created_at.to_s,
      'user_screen_name' => status.user.screen_name.to_s,
      'user_name' => status.user.name.to_s,
      'text' => status.text.to_s,
      'retweet_count' => status.retweet_count.to_s
    }
    if status.retweeted_status
      record['rt_created_at'] = status.retweeted_status.created_at.to_s
      record['rt_user_screen_name'] = status.retweeted_status.user.screen_name.to_s
      record['rt_user_name'] = status.retweeted_status.user.name.to_s
      record['rt_text'] = status.retweeted_status.text.to_s
      record['rt_retweet_count'] = status.retweeted_status.retweet_count.to_s
    end

    emit_message(record)
  end
  
  def emit_message(msg)
    begin
      Engine.emit(@tag, Engine.now, msg)
    rescue => e
      $log.error "unexpected error", :error=>$!.to_s
      $log.error_backtrace
    end
  end
end

end