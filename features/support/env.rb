require 'rubygems'
require 'bundler/setup'

require 'capybara/cucumber'
require 'capybara/spec/test_app'

case ENV['Environment']
  when 'stage' || 'Stage' then
    puts "Currently running in stage" # initialize Dev
  when 'Test' || 'test' then puts "currently running tests in tests-environment"# initialize QA
  else puts "Running in default environment"
end

Capybara.app = TestApp
