# frozen_string_literal: true

# A Regex extraction
module RegexExtractor
  GOOGLE_BASE_URL = 'https://www.google.com'

  def parse_regex(file_path)
    # Open the file with explicit UTF-8 encoding
    html_content = File.read(file_path, encoding: 'UTF-8')
                       .force_encoding('UTF-8')

    # Find matches and process them
    artworks = html_content.scan(item_regex).map do |href, image_key, image_src, name, extensions|
      {
        href: format_url(href),
        image: image_key || image_src, # Use image_key if available, otherwise use image_src
        name: name&.gsub(%r{</?span>|<wbr>}, ''), # Clean up the name
        extensions:
      }
    end

    { 'artworks' => artworks }
  end

  def item_regex
    # Regex to find all relevant data within <a class="klitem">
    %r{
      <a\s+class="klitem"[^>]*\s+       # Opening <a class="klitem">
      href="([^"]+)"[^>]*>              # Capturing the href attribute
      .*?                               # Match everything lazily until...
      <g-img[^>]*>\s*<img               # Start of the <img> element within <g-img>
      (?:[^>]*?data-key="([^"]+)"|[^>]*?data-src="([^"]+)")?  # Optionally capture data-key or data-src
      [^>]*>\s*</g-img>                 # Close <img> and <g-img> tags
      .*?                               # Continue lazily matching...
      <div\s+class="kltat">\s*          # Until the title division
      ((?:<span>[^<]+</span>\s*<wbr>\s*)*<span>[^<]+</span>)  # Capture names..
      .*?                               # Match everything lazily until...
      (?:<div\s+class="ellip\s+klmeta">(\d{4})</div>)?  # Optionally capture the year
    }xmsu
  end

  def extract_name(name)
    return '' if name.nil?

    # Clean up the string
    name.gsub(%r{</?span>|<wbr>}, '')
  end

  def format_url(url)
    if url.match(GOOGLE_BASE_URL)
      url
    else
      GOOGLE_BASE_URL + url
    end
  end
end
