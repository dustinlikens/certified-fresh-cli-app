require 'open-uri'
require 'nokogiri'
require 'capybara/poltergeist'
require 'phantomjs'

class Scraper

  def self.dom_from_url(url)
    # Capybara.register_driver(:poltergeist) do |app| 
    #   client = Capybara::Poltergeist::Driver.new(app, phantomjs_logger: nil, stdout: nil, timeout: 120, js_errors: false, debug: false, phantomjs_options: ['--load-images=false'] ) 
    # end
    # Capybara.default_driver = :poltergeist  # configure Capybara to use poltergeist as the driver
    # page = Capybara.current_session     # the object we'll interact with
    # page.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6' }
    # # url = "https://www.rottentomatoes.com/m/i_am_not_your_negro"
    # page.visit url
    # puts page.body
    # Nokogiri::HTML(page.body)
    Nokogiri::HTML(open('./fixtures/index.html'))
  end

  def self.page_from_url(url)
    Nokogiri::HTML(open(url))
  end

  def self.scrape_movie_list(url)
    movies_array = []
    page = dom_from_url(url)
    page.css('div.mb-movie').each do |m|
      movie_hash = {}
      
      movie_hash[:title] = m.css("h3.movieTitle").text

      relative_url = m.css("a").attribute("href").value
      movie_hash[:movie_url] = "https://www.rottentomatoes.com#{relative_url}"

      movies_array << movie_hash
    end
    movies_array
  end

  def self.scrape_movie_page(url)
    page = page_from_url(url)
    attr_hash = {}
    attr_hash[:critics_score] = page.css(".critic-score .meter-value")[0].text
    attr_hash[:audience_score] = page.css(".audience-score .meter-value")[0].text.strip
    attr_hash[:synopsis] = page.at_css("[id=movieSynopsis]").text.strip
    attr_hash[:consensus] = page.css("p.critic_consensus")[0].text.split("Critics Consensus:\n")[1].strip
    
    meta_list = page.css("ul.content-meta.info .meta-value")
    attr_hash[:rating] = meta_list[0].text
    attr_hash[:genres] = meta_list[1].css("a").map{|a|a.text.strip}
    attr_hash[:directors] = meta_list[2].css("a").map{|a|a.text.strip}
    attr_hash[:writers] = meta_list[3].css("a").map{|a|a.text.strip}
    attr_hash[:release_date] = meta_list[4].css("time").text
    attr_hash[:runtime] = meta_list[5].css("time").text.strip

    attr_hash
  end

end

# s = Scraper.new
# s.scrape_movie_list('https://www.rottentomatoes.com/browse/cf-in-theaters/?minTomato=70&certified=true')
# # s.scrape_movie_page('https://www.rottentomatoes.com/m/the_lego_batman_movie')

