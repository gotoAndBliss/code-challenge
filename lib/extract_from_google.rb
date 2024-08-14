# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'pry'

require_relative 'web_driver_setup'
require_relative 'nokogiri_extractor'
require_relative 'regex_extractor'

# Class for extracting pictures from Google Search Results
class ExtractFromGoogle
  extend NokogiriExtractor
  extend WebDriverSetup
  extend RegexExtractor

  def self.extract_picture_data_via_nokogiri(file_path)
    driver = create_driver

    navigate_to_file(driver, file_path)
    wait_for_page_load(driver)

    html_content = driver.page_source
    driver.quit

    parse_html(html_content)
  end

  def self.extract_picture_data_via_regex(file_path)
    parse_regex(file_path)
  end
end
