# frozen_string_literal: true

module Scrapers
  class BaseScraper
    attr_accessor :browser, :page

    def initialize
      @browser = init_browser
      @page = nil

      path = ENV['GOOGLE_CHROME_BIN'] || ENV['GOOGLE_CHROME_SHIM']
    end

    private

    def init_browser
      options = Selenium::WebDriver::Chrome::Options.new
      chrome_dir = Rails.root.join('tmp', 'chrome')
      FileUtils.mkdir_p(chrome_dir)
      user_data_dir = "--user-data-dir=#{chrome_dir}"
      options.add_argument user_data_dir
      options.add_argument "window-size=800x600"
      options.add_argument "headless"
      options.add_argument "disable-gpu"
      options.add_argument 'disable-setuid-sandbox'
      options.add_argument 'disable-dev-shm-usage'
      options.add_argument 'single-process'
      Watir::Browser.new :chrome, options: options
    end

    def scrape_page_from_url(before_events: false)
      raise 'Must set url' unless @url
      @browser.goto(@url)
      before_scrape_events if before_events
      @page = Nokogiri::HTML(@browser.html)
    end

    def before_scrape_events
      # override
    end
  end
end
