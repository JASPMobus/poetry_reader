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

  def self.read(title, author)
    poem = Poem.all.find { |poem|  poem.title.downcase == title.downcase }

    poem.read
  end

  def noko
    Nokogiri::HTML(open(self.url))
  end

  def read
    self.noko.css("div[style='text-indent: -1em; padding-left: 1em;']").each do |line|
      puts line.text
    end
  end
end
