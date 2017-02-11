require_relative '../lib/scraper.rb'
require_relative '../lib/movie.rb'
require 'colorize'

class CLI

  def run
    make_movies
    add_attributes_to_movies
    display_movies
    puts "Enter movie # to view additional details"
    display_movie_details(gets.strip)
  end

  def make_movies
    movie_array = Scraper.scrape_movie_list('https://www.rottentomatoes.com/browse/cf-in-theaters/?minTomato=70&certified=true')
    Movie.create_from_collection(movie_array)
  end

  def add_attributes_to_movies
    Movie.all.each do |movie|
      attr_hash = Scraper.scrape_movie_page(movie.movie_url)
      movie.add_movie_attributes(attr_hash)
    end
  end

  def display_movies
    n = 1
    Movie.all.each do |movie|
      puts "#{n}: #{movie.title} #{movie.critics_score}"
      n += 1
    end
  end

  def to_index(n)
    n.to_i - 1 
  end

  def display_movie_details(n)
    movie = Movie.all[to_index(n)]

    puts "#{movie.title.upcase}".colorize(:light_blue)
    puts "  Critics score: ".colorize(:light_blue) + "#{movie.critics_score}"
    puts "  Audience score: ".colorize(:light_blue) + "#{movie.audience_score}"
    puts "  Critics consensus: ".colorize(:light_blue) + "#{movie.consensus}"
    puts "  Rating: ".colorize(:light_blue) + "#{movie.rating}"
    puts "  Genre(s): ".colorize(:light_blue) + "#{movie.genres.join(', ')}"
    puts "  Director(s): ".colorize(:light_blue) + "#{movie.directors.join(', ')}"
    puts "  Writers(s): ".colorize(:light_blue) + "#{movie.writers.join(', ')}"
    puts "  Release date: ".colorize(:light_blue) + "#{movie.release_date}"
    puts "  Synopsis: ".colorize(:light_blue) + "#{movie.synopsis}"

  end

end


c = CLI.new
c.run