require 'bundler/setup'
Bundler.require(:default)

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_ACCESS_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

res = Connpass.event_search(series_id: 206)
exit if res.results_returned.zero?

now = Time.now.utc
res.events.reverse.each do |e|
  started_at = Time.parse(e.started_at).utc
  next if now > started_at
  tweet = %[【定期POST】#{e.title} #{started_at.strftime('%Y/%m/%d')}開催 #{e.event_url} ##{e.hash_tag}]
  if Twitter.credentials?
    Twitter.update(tweet)
    sleep(5)
  else
    puts tweet
  end
end
