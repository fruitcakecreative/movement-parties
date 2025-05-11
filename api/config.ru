require_relative "config/environment"
require 'yabeda/prometheus/exporter'

use Rack::Auth::Basic, "Protected Metrics" do |username, password|
  Rack::Utils.secure_compare("Bearer #{password}", "Bearer #{ENV['METRICS_TOKEN']}")
end if ENV['METRICS_TOKEN']

map '/metrics' do
  run Yabeda::Prometheus::Exporter
end

run Rails.application
