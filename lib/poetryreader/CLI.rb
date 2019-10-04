require "poetryreader/poet"

class CLI
  def run
    puts "PoetryReader uses the Poetry Foundation website to share poems with you! All you need to know is the author's name and the title! When inputting the author's name, be sure to put a space between each part, even if it's between two initials!"

    ask = ""
    ask_for_poet = true

    while true do
      if ask_for_poet
        puts "\nWhat author would you like to read a poem from? (help)"
        ask = gets.chop

        #if the user asks to exit, then we do so.
        if ask_compare(ask, "exit")
          exit!
        #if the user asks to list poets, we give them all poets that they've already created
        elsif ask_compare(ask, "list")
          Poet.all.each { |poet| puts poet.name }
        #if the user needs help, we give them all possible commands at this stage
        elsif ask_compare(ask, "help")
          puts "\n Put a poet's name if you'd like to read one of their poems.\n List lists all of the poets that you've already requested to read poems from during this use of poetryreader.\n Exit ends your use of poetryreader.\n And, of course, help tells you the above."
        #if none of these are the request, then we assume they've given us a poet's name
        else
          begin
            poet = Poet.find_or_create_new(ask)

            ask_for_poet = false
          #if there is no poet with this name, then we rescue and alert the user
          rescue OpenURI::HTTPError => error
            puts "\nThat poet or command cannot be found. Please check for typos and try again!"
          end
        end
      else
        puts "\nWhich of #{poet.name}'s poems would you like to read? (help)"
        ask = gets.chop

        #if the user asks to exit, then we do so.
        if ask_compare(ask, "exit")
          exit!
        #if the user asks to list the poet's poems, then we give them a list with all readable poems from that poet
        elsif ask_compare(ask, "list")
          poet.poems.each { |poem| puts poem.title }
        #if the user needs help, we give them all possible commands at this stage
        elsif ask_compare(ask, "help")
          puts "\n Put a poem's name if you'd like to read it.\n List lists all of the readable poems that the currently selected author wrote.\n Exit ends your use of poetryreader.\n And, of course, help tells you the above."
        #if none of these are the request, then we assume they've given us a poem's title
        else
          begin
            puts ""
            Poem.read(ask, poet)

            ask_for_poet = true
          #if there is no poem with this title and author, then we rescue and alert the user
          rescue NoMethodError => error
            puts "\nThat poem or command cannot be found. Please check for typos and try again!"
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
