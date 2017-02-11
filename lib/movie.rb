class Movie

  attr_accessor :title, :movie_url, :critics_score, :audience_score, :rating, :genres, :directors, :writers, :release_date, :runtime
  @@all = []

  def initialize(title,movie_url)
    @title = title
    @movie_url = movie_url
    save
  end

  def self.all?
    @@all
  end

  def save
    self.class.all << self
  end

  def self.create_from_collection(movie_array)
    movie_array.each {|movie| new(movie)}  #self.new??????
  end

  def self.add_movie_attributes(attr_hash)
    attr_hash.each do |key,value|
      self.send("#{key}=",value)
    end
  end

end