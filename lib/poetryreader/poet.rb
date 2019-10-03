gem 'nokogiri'

require 'nokogiri'
require 'open-uri'

require "poetryreader/poem"

class Poet
  attr_accessor :name

  @@all = []

  def initialize(name)
    @name = name

    #grabs all of their poems listed on the website at creation
    self.grab_poems

    @@all << self
  end

  def self.find_or_create_new(name)
    poet = self.all.find { |poet| poet.name.downcase.tr(".", "") == name.downcase.tr(".", "") }
    if poet
      poet
    else
      Poet.new(name)
    end
  end

  def self.all
    @@all
  end

  def self.clear_all
    @@all.clear
  end

  #uses a poet's name, which was given to the Object at creation (e.g. "e. e. cummings")
  def url
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
      if h3a['href'].start_with?(poem_url_start) && !Poem.all.find { |poem| poem.title == h3a.text }
          Poem.new(h3a.text, self, h3a['href'])
      end
    end
  end

  def poems
    poems = Poem.all.filter { |poem| poem.author == self }
  end
end
