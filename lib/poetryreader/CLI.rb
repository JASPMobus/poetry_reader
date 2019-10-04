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

        #if the user asks to list poets, we give them all poets that they've already created
        if ask_compare(ask, "list")
          Poet.all.each { |poet| puts poet.name }
        #if the user asks to exit, then we do so.
        elsif ask_compare(ask, "exit")
          exit!
        else
          begin
            poet = Poet.find_or_create_new(ask)

            ask_for_poet = false
          #if there is no poet with this name, then we rescue and alert the user
          rescue OpenURI::HTTPError => error
            puts "That poet cannot be found. Please check for typos and try again!\n"
          end
        end
      else
        puts "Which of #{poet.name}'s poems would you like to read?"
        ask = gets.chop

        #if the user asks to list the poet's poems, then we give them a list with all readable poems from that poet
        if ask_compare(ask, "list")
          poet.poems.each { |poem| puts poem.title }
        #if the user asks to exit, then we do so.
        elsif ask_compare(ask, "exit")
          exit!
        #then we assume it's a poem's title
        else
          begin
            Poem.read(ask, poet)

            ask_for_poet = true
          #if there is no poem with this title and author, then we rescue and alert the user
          rescue NoMethodError => error
            puts "That poem cannot be found. Please check for typos and try again!\n"
          end
        end
      end
    end
  end

  def ask_compare(ask, compare)
    #compares ask and compare, if ask begins with all the right words of compare, regardless of case, then we assume that they're trying to use the compare keyword
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
