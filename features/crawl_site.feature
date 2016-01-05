@selenium
Feature: Visit ATV base URL and crawl site

  @1
  Scenario: Smoketest of AppleTV
    When I want to test AppleTV
    And Capybara should use the "selenium" driver
    And I look up xml startpages for Apple TV
    Then all pages should be availale and have correct syntax

  @2
  Scenario: program ids
    When I want to test AppleTV
    When I go to the start endpoints for Apple TV Super
    Then all programs should be available

