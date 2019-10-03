require "poetryreader/poet"

class CLI
  def run
    puts "PoetryReader uses the Poetry Foundation website to share poems with you! All you need to know is the author's name and the title!\nWhen inputting the author's name, be sure to put a space between each part, even if it's between two initials!"

    ask = ""
    ask_for_poet = true

    while true do
      if ask_for_poet
        puts "What author would you like to read a poem from?"
        ask = gets.chop

        if ask.downcase == "list poets" || ask.downcase == "list"
          Poet.all.each { |poet| puts poet.name }
        elsif ask == "exit"
          exit!
        else
          poet = Poet.find_or_create_new(ask)

          ask_for_poet = false
        end
      else
        puts "Which of #{poet.name}'s poems would you like to read?"
        ask = gets.chop

        if ask.downcase == "list poems" || ask.downcase == "list"
          poet.poems.each { |poem| puts poem.title }
        elsif ask == "exit"
          exit!
        else
          Poem.read(ask, poet)
          puts ""

          ask_for_poet = true
        end
      end
    end
  end
end
