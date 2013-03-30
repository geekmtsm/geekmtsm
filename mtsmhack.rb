require File.expand_path('../boot', __FILE__)

now = Time.now.utc
exit unless [2, 4, 6].include?(now.wday)

res = Connpass.event_search(series_id: 206)
exit if res.results_returned.zero?

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
