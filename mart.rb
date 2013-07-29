require File.expand_path('../boot', __FILE__)
require 'open-uri'
require 'active_support/core_ext/hash/conversions'

HASHTAG = '#元住吉'
SHUFOO_MAXVALUE_URL = 'http://www.shufoo.net/shxweb/site/shopDetailNewXML/109667'
today = Date.today
tweets = []

xml = open(SHUFOO_MAXVALUE_URL).read.encode('UTF-8')
shop = Hashie::Rash.new(Hash.from_xml(xml)).shop
if shop.chirashis.is_a?(Hashie::Rash) && flyer = shop.chirashis.chirashi
  started_on = flyer.publish_start_time.slice(0, 10)
  ended_on = flyer.publish_end_time.slice(0, 10)
  if started_on == today.strftime('%Y/%m/%d')
    tweets << "【チラシ更新】#{shop.shop_name} (#{started_on}〜#{ended_on}) #{flyer.portal} #{HASHTAG}"
  end
end

case today.day
when 20, 30
  tweets << "【SALE】マックスバリュエクスプレス木月住吉店 毎月20日・30日はお客さま感謝デー！イオンカード提示で5%オフ！ #{HASHTAG}"
when 9, 19, 29
  tweets << "【SALE】生鮮市場ダイイチ 9のつく日は肉10%オフ！ #{HASHTAG}"
end

if Twitter.credentials?
  tweets.each do |t|
    Twitter.update(t)
    sleep(5)
  end
else
  puts tweets
end
