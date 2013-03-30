require File.expand_path('../boot', __FILE__)

case Date.today.day
when 9, 19, 29
  tweet = '生鮮市場ダイイチ 9のつく日は肉10%オフ！'
end

Twitter.update(tweet) if Twitter.credentials?
