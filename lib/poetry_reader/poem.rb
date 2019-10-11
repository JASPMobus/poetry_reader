gem 'nokogiri'

require 'nokogiri'
require 'open-uri'

class Poem
  attr_accessor :title, :comparator_title, :author, :url

  @@all = []

  def initialize(title, author, url)
    @title = title
    @comparator_title = comparatise(title)
    @author = author
    @url = url

    @@all << self
  end

  def self.all
    @@all
  end

  def self.read(title, author)
    #finds the poem with the given title and author and reads it
    poem = Poem.all.find { |poem|  poem.comparator_title.downcase == title.downcase && poem.author == author }

    poem.read
  end

  def noko
    Nokogiri::HTML(open(self.url))
  end

  def read
    #grabs the poem from the page given by its url (found from the poet's page) and prints it to the terminal
    self.noko.css("div[style='text-indent: -1em; padding-left: 1em;']").each do |line|
      puts line.text
    end
  end

  def comparatise(word)
    ret = ""

    word.split("").each do |letter|
      ret = ret + letter.unicode_normalize(:nfkd).chars[0]
    end

    ret
  end
end
