gem 'nokogiri'

require 'nokogiri'
require 'open-uri'

class Poem
  attr_accessor :title, :author, :url

  @@all = []

  def initialize(title, author, url)
    @title = title
    @author = author
    @url = url

    @@all << self
  end

  def self.all
    @@all
  end
  
  def self.clear_all
    @@all.clear
  end
  
  def self.read_by_title_and_author(title, author)
    poem = @@all.find { |poem| poem.title == title && poem.author == author }
    
    if !poem
      puts "Sorry, that poem could not be found."
    else
      poem.read
    end
  end
  
  def noko
    Nokogiri::HTML(open(self.url))
  end

  def read
    self.noko.css("div.o-poem")
  end
end