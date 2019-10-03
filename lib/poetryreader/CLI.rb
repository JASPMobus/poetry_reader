require "poetryreader/poet"

class CLI
  def run 
    puts "PoetryReader uses the Poetry Foundation website to share poems with you! All you need to know is the author's name and the title!\nWhen inputting the author's name, be sure to put a space between each part, even if it's between two initials!"
    
    ask = ""

    until ask == "end" do
      puts "What author would you like to read a poem from?"
      poet = Poet.new(gets)
      
      poet.grab_poems
      poet.poems.each do |poem|
        puts poem.title
      end
      puts "Which of their poems (above) would you like to read?"
      
      Poem.read_by_title_and_author(gets, poet)
    end
  end
end