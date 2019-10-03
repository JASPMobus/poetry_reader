gem 'nokogiri'

require 'nokogiri'
require 'open-uri'

require "poetryreader/poem"

class Poet
  attr_accessor :name, :grabbed

  @@all = []

  def initialize(name)
    @name = name

    @@all << self
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
    poem_url_start = "https://www.poetryfoundation.org/poetrymagazine/poems/"
    
    self.noko.css("h3.c-hdgSans_5 a").each do |h3a|
      Poem.new(h3a.text, self, h3a['href'])
    end 
    
    @grabbed = true
  end 
  
  def poems 
    if !@grabbed
      self.grab_poems
    end
    
    poems = Poem.all.filter { |poem| poem.author == self }
  end
end