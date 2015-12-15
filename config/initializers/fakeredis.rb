# config/initializers/fakeredis.rb

if Rails.env.development? || Rails.env.test?

  # Monkey-patch the in-memory connection to redis to match Redic
  class Redis::Connection::Memory
    def call method, *args
      self.send(method.to_s.downcase, *args)
    end
  end

end
