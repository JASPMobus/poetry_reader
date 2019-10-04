gem 'nokogiri'

require 'nokogiri'
require 'open-uri'

class Poet
  attr_accessor :name, :url

  @@all = []

  def initialize(name, url = nil)
    @name = name

    if !url
      @url = self.create_url
    else
      @url = url
    end

    @name = self.grab_name

    #grabs all of their poems listed on the website at creation
    self.grab_poems

    @@all << self
  end

  def self.find_or_create_new(name, url = nil)
    #compares the given name to @@all poets, if it's found, we use that poet, otherwise we create a new one with the given name
    poet = self.all.find { |poet| poet.name.downcase.tr(".", "") == name.downcase.tr(".", "") }
    if poet
      poet
    else
      Poet.new(name, url)
    end
  end

  def self.all
    @@all
  end

  #uses a poet's name, which was given to the Object at creation (e.g. "e. e. cummings")
  def create_url
    #we trim away all periods and break apart the name by spaces to use to acquire the url of the poet in the Poetry Foundation website
    name_no_periods = @name.tr(".", "")
    name_no_periods = name_no_periods.split(" ")

    #we use name_no_periods to generate the url for the poet (example url: "https://www.poetryfoundation.org/poets/ben-jonson")
    url = "https://www.poetryfoundation.org/poets/"
    name_no_periods.each { |part| url = "#{url}#{part}-"}

    #this leaves an extra hyphen at the end, but we can just cut that off in the return.
    url = url.chop
  end

  def noko
    Nokogiri::HTML(open(self.url))
  end

  def grab_poems
    #all readable poem url-s start with this string
    poem_url_start = "https://www.poetryfoundation.org/poems/"

    #check each of the listed entries in the box at the bottom of the page to make sure that they're
    #poems and that they haven't already been generated
    self.noko.css("h3.c-hdgSans_5 a").each do |h3a|
      if h3a['href'].start_with?(poem_url_start) && !Poem.all.find { |poem| poem.title == h3a.text && poem.author == self }
          Poem.new(h3a.text, self, h3a['href'])
      end
    end
  end

  def grab_name
    #finds the way Poetry Foundation says the poet's name and updates the Poet Object's name attribute
    self.noko.css("h1.c-hdgSerif_1").text
  end

  def poems
    #finds all Poem Objects made with the author listed as this Poet Object
    poems = Poem.all.filter { |poem| poem.author == self }
  end

  def self.recommend
    noko = Nokogiri::HTML(open("https://www.poetryfoundation.org/poets"))

    noko.css("h2.c-hdgSans_2 a").each do |h2a|

      possible_recommendation = self.find_or_create_new(h2a.text, h2a['href'])

      if possible_recommendation.poems == []
        @@all.delete(possible_recommendation)
      end
    end

    @@all.each do |poet|
      puts poet.name
    end
  end

  def read_bio
    puts self.noko.css("div.c-userContent p").text
  end
end
