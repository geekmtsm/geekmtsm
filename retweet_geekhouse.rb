require File.expand_path('../boot', __FILE__)
require 'open-uri'

@rubytter = Rubytter.new
date = Date.today.strftime('%Y-%m-%d')
i = 1
loop do
  tweets = @rubytter.search("ギークハウス since:#{date}", page: i)
  break if tweets.empty?

  tweets.each do |t|
    next if t.text.include?('RT')
    next if t.text.chars.first == '@'

    url = "https://twitter.com/#{t.user.screen_name}/status/#{t.id}"
    html = Nokogiri.HTML(open(url))
    next if html.search('ul.stats').empty?

    if Twitter.credentials?
      Twitter.retweet!(t.id)
      sleep(5)
    else
      puts t.text
    end
  end
  i += 1
end
