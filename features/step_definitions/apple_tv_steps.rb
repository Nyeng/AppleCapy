require_relative '../../library/apple_tv_base'
#include Apple


Given(/^I want to test AppleTV$/) do
  @appletv = AppleTvBase.new('atv')
end

Given(/^I want to test Super AppleTV$/) do
  @superatv = AppleTvBase.new('super')
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
  #
end


When(/^I check out non\-buildable paths$/) do
  @appletv.check_non_buildable_paths
end

Then(/^all paths should be available$/) do

end

When(/^I lookup subpages from paths$/) do
  @appletv.verify_pages_from_paths
end

Then(/^the subpages should be available$/) do

end

And(/^I look up xml startpages for Super Apple TV$/) do
  @superatv.verify_main_site
end