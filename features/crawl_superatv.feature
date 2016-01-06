@selenium
Feature: Visit Super ATV base URL and crawl site

  @1
  Scenario: Smoketest of Super AppleTV
    Given I want to test Super AppleTV
    And Capybara should use the "selenium" driver
    And I look up xml startpages for Super Apple TV