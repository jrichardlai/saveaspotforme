Taskrabbit.configure do |config|
  config.api_key       = ENV['TASKRABBIT_KEY']
  config.api_secret    = ENV['TASKRABBIT_SECRET']
  config.base_uri      = ENV['TASKRABBIT_URI']
end