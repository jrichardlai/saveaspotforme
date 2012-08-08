extra_options = { :client_options => { :site => ENV['TASKRABBIT_URI'] } }

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :taskrabbit, ENV['TASKRABBIT_KEY'], ENV['TASKRABBIT_SECRET'], extra_options
end