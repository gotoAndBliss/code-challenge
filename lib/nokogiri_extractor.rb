# frozen_string_literal: true

# Nokogiri / Headless Browser Extractor
module NokogiriExtractor
  GOOGLE_BASE_URL     = 'https://www.google.com'
  EXTENSION_SELECTORS = '.ellip, .klmeta'

  def parse_html(html_content)
    doc = Nokogiri::HTML(html_content)
    extract_artworks_from_carousel(doc)
  end

  def navigate_to_file(driver, path_or_url)
    if path_or_url =~ /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
      # Allow live URL's to be passed
      driver.get(path_or_url)
    else
      # Or a file path
      driver.get("file://#{File.expand_path(path_or_url)}")
    end
    sleep 1 # Allow driver to load
  end

  def extract_artworks_from_carousel(html)
    carousel = html.at_css('g-scrolling-carousel')
    artworks = carousel.css('a').map { |item| extract_artwork(item) }
    { 'artworks' => artworks }
  end

  def extract_artwork(item)
    name = item['data-entityname'] || item['aria-label']
    extensions = item.css(EXTENSION_SELECTORS).map(&:text).map(&:strip)
    link = extract_url(item)
    image = extract_image_src(item)
    {
      'name' => name,
      'extensions' => extensions,
      'link' => link,
      'image' => image
    }.compact
  end

  def extract_text(item, selector)
    element = item.at_css(selector)
    element&.text&.strip
  end

  def extract_url(item)
    # Absolute URL's match the expected-array.json
    if item['href'].match(GOOGLE_BASE_URL)
      item['href']
    else
      GOOGLE_BASE_URL + item['href']
    end
  end

  def extract_image_src(item)
    image = item.at_css('img')
    image ? image['src'] : nil
  end
end
