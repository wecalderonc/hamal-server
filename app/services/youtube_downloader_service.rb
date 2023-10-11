# app/services/youtube_downloader_service.rb

require 'selenium-webdriver'
require 'net/http'
require 'uri'

class YoutubeDownloaderService
  def self.download_mp3(url, title)
    setup_firefox_and_navigate(url)
    download_href = fetch_download_link
    destination_path = File.join(Rails.root, 'tmp', "#{title}.mp3")
    download_file(download_href, destination_path)
    destination_path
  end

  private

  def self.setup_firefox_and_navigate(url)
    puts "Setting up Firefox preferences..."

    download_directory = File.expand_path(Rails.root.join('tmp'))
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.dir'] = download_directory
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'audio/mpeg, audio/mp3'

    options = Selenium::WebDriver::Firefox::Options.new
    options.profile = profile
    options.add_argument('--headless')

    puts "Starting Firefox in headless mode..."
    @driver = Selenium::WebDriver.for :firefox, options: options

    puts "Navigating to y2mate..."
    @driver.navigate.to 'https://www.y2mate.com/en1879/youtube-mp3'

    puts "Entering video URL..."
    input_element = @driver.find_element(name: 'query')
    input_element.send_keys(url)

    puts "Submitting the form..."
    submit_button = @driver.find_element(id: 'btn-submit')
    submit_button.click
  end

  def self.fetch_download_link
    puts "Waiting for the download link to appear..."
    wait = Selenium::WebDriver::Wait.new(timeout: 10)
    first_download_link = wait.until { @driver.find_element(id: 'process_mp3') }
    first_download_link.click

    puts "Locating the final download link..."
    download_link_element = wait.until { @driver.find_element(css: ".btn.btn-success.btn-file") }

    puts "Fetching the href attribute..."
    download_href = download_link_element.attribute("href")

    puts "Download should have started. Closing the browser..."
    @driver.quit

    download_href
  end

  def self.download_file(url, destination_path)
    puts "Downloading file from #{url} to #{destination_path}..."

    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      File.open(destination_path, 'wb') do |file|
        file.write(response.body)
      end
      puts "Download complete!"
    else
      puts "Failed to download file: #{response.message} (#{response.code})"
    end
  end
end
