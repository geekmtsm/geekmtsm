require File.expand_path('../boot', __FILE__)

friend_ids = Twitter.friend_ids.ids
follower_ids = Twitter.follower_ids.ids
followback_ids = follower_ids - friend_ids
followback_ids.each{|f| Twitter.follow(f) } if 0 < followback_ids.size
