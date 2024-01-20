module MasterMind
  COLORS = ["red", "yellow", "green", "blue", "purple", "orange"]
  SIZE = 4
  class Game
    def choose_color
      answer = Array.new(SIZE) {COLORS.sample}
      p answer
    end

    def take_guess
      print "Enter your guess: "
      guesses = gets.chomp.split(", ")
      raise "Invalid Guess: Not enough number of color or invalid color" unless check_guess(guesses)
    end

    def check_guess(guesses)
      return false if guesses.length != 4
      guesses.each do |guess|
        return false unless answer.include?(guess)
      end
    end
      
    def play
      puts "COLORS: #{COLORS}\n"
      choose_color
      result = nil
      until result
        begin
          take_guess
        rescue RuntimeError => e
          puts e.message
          retry
        end
      end
    end
  end
end

include MasterMind

system "clear"
puts "Welcome player!"

ready = false
until ready
  puts "Select your character:", "1. The Creator", "2. The Guesser", "Other. Exit"
  selection = gets.chomp.to_i
  if selection == 1
    Game.new.play
    ready = true
  elsif selection == 2
    ready = true
  else
    ready = true
  end
end

puts "\n-----------------------------------"
puts "Goodbye, have a good day with Odin!"
puts "\n-----------------------------------"

