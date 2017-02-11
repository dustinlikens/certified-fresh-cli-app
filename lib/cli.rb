require_relative '../lib/scraper.rb'
require_relative '../lib/movie.rb'
require 'colorize'

class CLI

  def run
    puts "\nWelcome to Certified Fresh! I will retieve a list of new-release movies from Rottentomatoes.com with critics' scores over 70%.\n\n"
    make_movies
    add_attributes_to_movies
    display_movies
    display_prompt
  end

  def determine_url
    puts "Please select a display mode:"
    puts "  1: Top 30 By score"
    puts "  2: Top 30 By release date"
    puts "  3: Top 30 By popularity"
    input = gets.strip
    case input
    when "1"
      "https://www.rottentomatoes.com/browse/cf-in-theaters/?minTomato=70&sortBy=tomato&certified=true"
    when "2"
      "https://www.rottentomatoes.com/browse/cf-in-theaters/?minTomato=70&sortBy=release&certified=true"
    when "3"
     "https://www.rottentomatoes.com/browse/cf-in-theaters/?minTomato=70&certified=true"
    else
      puts "Invalid input!"
      determine_url
    end
  end

  def display_prompt
    loop do
      puts 'Enter movie # to view additional details, "n" for new display mode, or "q" to quit.'
      input = gets.strip
      if input.to_i.between?(1,Movie.all.length)
        display_movie_details(input)
      elsif input == "n"
        make_movies
      elsif input == "q"
        break
      else
        puts "Invalid input!"
      end
      # input == "q" ? break : display_movie_details(input)
      # # display_movie_details(gets.strip)
    end
  end

  def make_movies
    movie_array = Scraper.scrape_movie_list(determine_url)
    Movie.create_from_collection(movie_array)
  end

  def add_attributes_to_movies
    scraped_movies = 0
    Movie.all.each do |movie|
      attr_hash = Scraper.scrape_movie_page(movie.movie_url)
      movie.add_movie_attributes(attr_hash)
      scraped_movies += 1
      puts "#{scraped_movies} of #{Movie.all.length} movies scraped..."
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


# c = CLI.new
# c.run