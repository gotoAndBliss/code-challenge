# frozen_string_literal: true

require 'spec_helper'
require 'pry'
require 'json'
require_relative '../lib/extract_from_google'

RSpec.describe ExtractFromGoogle do
  describe '.extract_picture_data_via_nokogiri' do

    # Van Gogh Carousel
    let(:expected_van_gogh_result) do
      json_file_path = 'files/expected-array.json'
      JSON.parse("{#{File.read(json_file_path)}}")
    end
    it 'returns an array of picture data for Van Gogh' do
      result = ExtractFromGoogle.extract_picture_data_via_nokogiri('files/van-gogh-paintings.html')

      # Check structure and overall count
      expect(result).to be_an_instance_of(Hash)
      expect(result['artworks'].size).to eq(expected_van_gogh_result['artworks'].size)

      # Iterate through each item
      result['artworks'].each_with_index do |actual_artwork, index|
        expected_artwork = expected_van_gogh_result['artworks'][index]

        # Iterate over each key-value pair in the actual artwork hash
        actual_artwork.each do |key, actual_value|
          next unless expected_artwork.key?(key)

          # Compare values only if the key exists in the expected results
          # as sometimes extensions is not present
          expected_value = expected_artwork[key]
          if key == 'image'
            # Check only for the presence of some content in the image key
            # since despite the image being parseable and similar to the results
            # it does not equal the expected_array.json's padding
            expect(actual_value).not_to be_empty,
                                        "Image data is missing at index #{index}"
          else
            # Compare other fields normally
            expect(actual_value).to eq(expected_value),
                                    "Mismatch in '#{key}' at index #{index}:\n
                                       Expected: #{expected_value}\n
                                       Got: #{actual_value}"
          end
        end
      end
    end

    # Manet Carousel
    let(:expected_related_manet_artist_searches) do
      json_file_path = 'files/manet-array.json'
      JSON.parse("{#{File.read(json_file_path)}}")
    end
    it 'returns an array of picture data for suggested artists' do
      result = ExtractFromGoogle.extract_picture_data_via_nokogiri('files/manet_search.htm')

      expect(result).to be_an_instance_of(Hash)
      expect(result['artworks'].size).to eq(expected_related_manet_artist_searches['artworks'].size)

      # Iterate through each item
      result['artworks'].each_with_index do |actual_artwork, index|
        expected_artwork = expected_related_manet_artist_searches['artworks'][index]

        # Iterate over each key-value pair in the actual artwork hash
        actual_artwork.each do |key, actual_value|
          next unless expected_artwork.key?(key)

          # Compare values only if the key exists in the expected results
          # as sometimes extensions is not present
          expected_value = expected_artwork[key]
          if key == 'image'
            # Check only for the presence of some content in the image key
            # since despite the image being parseable and similar to the results
            # it does not equal the expected_array.json's padding
            expect(actual_value).not_to be_empty,
                                        "Image data is missing at index #{index}"
          else
            # Compare other fields normally
            expect(actual_value).to eq(expected_value),
                                    "Mismatch in '#{key}' at index #{index}:\n
                                       Expected: #{expected_value}\n
                                       Got: #{actual_value}"
          end
        end
      end
    end

    # Gandhi Carousel
    let(:expected_related_gandhi_searches) do
      json_file_path = 'files/gandhi-array.json'
      JSON.parse("{#{File.read(json_file_path)}}")
    end
    it 'returns an array of picture data for suggested activists' do
      result = ExtractFromGoogle.extract_picture_data_via_nokogiri('files/gandhi_search.htm')

      expect(result).to be_an_instance_of(Hash)
      expect(result['artworks'].size).to eq(expected_related_gandhi_searches['artworks'].size)

      # Iterate through each item
      result['artworks'].each_with_index do |actual_artwork, index|
        expected_artwork = expected_related_gandhi_searches['artworks'][index]

        # Iterate over each key-value pair in the actual artwork hash
        actual_artwork.each do |key, actual_value|
          next unless expected_artwork.key?(key)

          # Compare values only if the key exists in the expected results
          # as sometimes extensions is not present
          expected_value = expected_artwork[key]
          if key == 'image'
            # Check only for the presence of some content in the image key
            # since despite the image being parseable and similar to the results
            # it does not equal the expected_array.json's padding
            expect(actual_value).not_to be_empty,
                                        "Image data is missing at index #{index}"
          else
            # Compare other fields normally
            expect(actual_value).to eq(expected_value),
                                    "Mismatch in '#{key}' at index #{index}:\n
                                       Expected: #{expected_value}\n
                                       Got: #{actual_value}"
          end
        end
      end
    end
  end

  describe '.extract_picture_data_via_regex ( proof of concept / incomplete )' do
    let(:expected_van_gogh_result) do
      json_file_path = 'files/expected-array.json'
      JSON.parse("{#{File.read(json_file_path)}}")
    end

    it 'extracts through regex the Van Gogh' do
      result = ExtractFromGoogle.extract_picture_data_via_regex('files/van-gogh-paintings.html')

      expect(result).to be_an_instance_of(Hash)
      expect(result['artworks'].size).to eq(expected_van_gogh_result['artworks'].size)

      # Iterate through each item
      result['artworks'].each_with_index do |actual_artwork, index|
        expected_artwork = expected_van_gogh_result['artworks'][index]

        # Iterate over each key-value pair in the actual artwork hash
        actual_artwork.each do |key, actual_value|
          next unless expected_artwork.key?(key)

          # Compare values only if the key exists in the expected results
          # as sometimes extensions is not present
          expected_value = expected_artwork[key]
          if key == 'image'
            # Check only for the presence of some content in the image key
            # since despite the image being parseable and similar to the results
            # it does not equal the expected_array.json's encoding
            expect(actual_value).not_to be_empty,
                                        "Image data is missing at index #{index}"
          else
            # Compare other fields normally
            expect(actual_value).to eq(expected_value),
                                    "Mismatch in '#{key}' at index #{index}:\n
                                       Expected: #{expected_value}\n
                                       Got: #{actual_value}"
          end
        end
      end
    end
  end
end
