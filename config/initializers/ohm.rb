# config/initializers/ohm.rb

# Configure our connections:
Ohm.redis = Redic.new("redis://127.0.0.1:6379")
