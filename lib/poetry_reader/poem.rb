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

  def self.read_by_title(title)
    #finds the poem with the given title
    poem = Poem.all.find { |poem|  poem.comparator_title.downcase == title.downcase }

    #if it wasn't already made, we make it (and its author)
    if !poem
      #we find the search page for the poem's title, and grab info we need from that
      url = self.search_title(title)
      poem_title = Nokogiri::HTML(open(url)).css("h2.c-hdgSans a")[0].text
      author_name = Nokogiri::HTML(open(url)).css("div.c-feature-sub span")[0].text

      #We grabbed "By <Author Name>", so we cut off the first three characters to make it "<Author Name>"
      3.times do
        author_name[0] = ""
      end

      #We make the author and the poem objects
      author = Poet.find_or_create_new(author_name)
      poem = Poem.all.find { |poem|  poem.comparator_title.downcase == title.downcase }

      #tell the user which poem we found and read it to them
      puts "Found: #{poem.title} by #{author.name}"
    end

    #finally, we read it
    poem.read
  end

  def self.search_title(title)
    #example of a search url https://www.poetryfoundation.org/search?query=dover+beach
    url = "https://www.poetryfoundation.org/search?query="

    #split the title by spaces because we need them to be +-s
    parts = title.split(" ")

    #put +-s in between each of the parts and append them to the end of the base url string
    parts.each do |part|
      url = "#{url}#{part}+"
    end

    #we have 1 too many +-s, so let's just cut the last one off when we return
    #also, we refine the search to just poems, so that it won't try to grab authors
    "#{url.chop}&refinement=poems"
  end

  def noko
    #returns the html from nokogiri-ing the url
    Nokogiri::HTML(open(self.url))
  end

  def read
    #grabs the poem from the page given by its url (found from the poet's page) and prints it to the terminal
    self.noko.css("div[style='text-indent: -1em; padding-left: 1em;']").each do |line|
      puts line.text
    end
  end

  def comparatise(word)
    #makes any nonstandard characters of word into standard latin characters.
    ret = ""

    #evaluates each character individually
    word.chars.each do |letter|
      ret = ret + letter.unicode_normalize(:nfkd).chars[0]
    end

    ret
  end
end
