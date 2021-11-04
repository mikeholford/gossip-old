unless Rails.env.test?
  $redis = Redis::Namespace.new("gossip", :redis => Redis.new)
end
