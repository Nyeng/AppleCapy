@selenium
Feature: Visit ATV base URL and crawl site

  @1
  Scenario: Smoketest of AppleTV
    Given I want to test AppleTV
    And Capybara should use the "selenium" driver
    And I look up xml startpages for Apple TV
    Then all pages should be availale and have correct syntax

  @2
  Scenario: program ids
    Given I want to test AppleTV
    When I go to the start endpoints for Apple TV Super
    Then all programs should be available

  @3
  Scenario: Paths
    Given I want to test AppleTV
    When I check out non-buildable paths
    Then all paths should be available

  @4
  Scenario: Verify sub pages from paths
    Given I want to test AppleTV
    When I lookup subpages from paths
    Then the subpages should be available









