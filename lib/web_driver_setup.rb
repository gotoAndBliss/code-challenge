# frozen_string_literal: true

require 'selenium-webdriver'

# Setup for Headless Selenium Driver
module WebDriverSetup
  def create_driver
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')

    Selenium::WebDriver.for(:chrome, options:)
  end

  def wait_for_page_load(driver)
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    wait.until { driver.execute_script('return document.readyState') == 'complete' }
  end
end
