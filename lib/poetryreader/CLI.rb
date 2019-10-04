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

        if ask_compare(ask, "list")
          Poet.all.each { |poet| puts poet.name }
        elsif ask_compare(ask, "exit")
          exit!
        else
          begin
            poet = Poet.find_or_create_new(ask)

            ask_for_poet = false
          rescue OpenURI::HTTPError => error
            puts "That poet cannot be found. Please check for typos and try again!\n"
          end
        end
      else
        puts "Which of #{poet.name}'s poems would you like to read?"
        ask = gets.chop

        if ask_compare(ask, "list")
          poet.poems.each { |poem| puts poem.title }
        elsif ask_compare(ask, "exit")
          exit!
        else
          begin
            Poem.read(ask, poet)

            ask_for_poet = true
          rescue NoMethodError => error
            puts "That poem cannot be found. Please check for typos and try again!\n"
          end
        end
      end
    end
  end

  def ask_compare(ask, compare)
    ask = ask.downcase.split(" ")
    compare = compare.split(" ")

    compare.length.times do |i|
      if ask[i] != compare[i]
        return false
      end
    end

    true
  end
end
