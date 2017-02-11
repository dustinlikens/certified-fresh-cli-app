class Movie

  attr_accessor :title, :movie_url, :critics_score, :audience_score, :rating, :genres, :directors, :writers, :release_date, :runtime, :synopsis, :consensus
  @@all = []

  def initialize(movie_hash)
    @title = movie_hash[:title]
    @movie_url = movie_hash[:movie_url]
    save
  end

  def self.all
    @@all
  end

  def save
    self.class.all << self
  end

  def self.create_from_collection(movie_array)
    movie_array.each do |movie_hash| 
      new(movie_hash)
    end
  end

  def add_movie_attributes(attr_hash)
    attr_hash.each do |key,value|
      self.send("#{key}=",value)
    end
  end

end