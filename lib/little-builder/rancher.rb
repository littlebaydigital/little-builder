require 'rancher/api'

def initialize(url, access_key, secret_key)
  Rancher::Api.configure do |config|
    config.url = 
    config.access_key = 
    config.secret_key = 
  end
end

