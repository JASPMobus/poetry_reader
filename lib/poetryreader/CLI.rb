require "poetryreader/poet"

class CLI
  def run
    puts "PoetryReader uses the Poetry Foundation website to share poems with you! All you need to know is the author's name and the title!\nWhen inputting the author's name, be sure to put a space between each part, even if it's between two initials!"

    ask = ""

    while ask != "y" do
      puts "What author would you like to read a poem from?"

      ask = gets

      poet = Poet.find_or_create_new(ask)

      #lists the poet's poems
      poet.poems.each do |poem|
        puts poem.title
      end

      puts "Which of their poems (above) would you like to read?"

      ask = gets

      Poem.read(ask, poet)

      puts "Would you like to end? y/(n)"

      ask = gets
    end
  end
end
