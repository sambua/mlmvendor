RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :request
end
