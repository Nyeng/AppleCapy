require_relative '../../library/apple_tv_base'
#include Apple


When(/^I want to test AppleTV$/) do
  @appletv = AppleTvBase.new('atv')
  #visit '/'
end

When(/^I look up xml startpages for Apple TV$/) do
  @appletv.verify_main_site
end

Then(/^all pages should be availale and have correct syntax$/) do

end

When(/^I go to the start endpoints for Apple TV Super$/) do
  @appletv.verify_super_start_availability
end

Then(/^all programs should be available$/) do

end


When(/^I check out non\-buildable paths$/) do
  @appletv.check_non_buildable_paths
end