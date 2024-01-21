module MasterMind
  COLORS = ["red", "yellow", "green", "blue", "purple", "orange"]
  MAX_TURNS = 12

  class Game
    def initialize
      @secret_code = []
      @role = select_role
      @turn = 1
    end
    
    def select_role
      print "Do you want to be the code maker (enter 'M') or code breaker (enter 'B')? "
      role_input = gets.chomp.upcase
      case role_input
      when 'M' then :maker
      when 'B' then :breaker
      else
        puts "Invalid input. Please enter 'M' or 'B'."
        select_role
      end
    end
    
    def play
      system "clear"
      puts "Welcome to Mastermind!"
      puts "Here are the available colors for the code: #{COLORS}!"
      generate_secret_code if @role == :maker
      auto_generate_secret_code if @role == :breaker

      while @turn <= MAX_TURNS
        guess = @role == :breaker ? human_guess : computer_guess
        exact_matches, color_matches = evaluate_guess(@secret_code, guess)
        display_board(guess, exact_matches, color_matches)
        if exact_matches == 4 && @role == :breaker
          puts "Congratulations! You guessed the correct code.\n"
          return
        elsif exact_matches == 4 && @role == :maker
          puts "Game Over. The computer broke your code.\n"
          return
        end
        @turn += 1
      end
  
      puts "Sorry, you've run out of turns. The correct code was #{@secret_code}."
    end

    def generate_secret_code
      print "Enter your secret code: "
      secret_input = gets.chomp.split(", ")
      unless valid_input?(secret_input)
        puts "Invalid input. Please enter 4 colors using the colors #{COLORS}."
        return generate_secret_code
      end
      @secret_code = secret_input
    end

    def auto_generate_secret_code
      @secret_code = Array.new(4) { COLORS.sample }
      p @secret_code
    end

    def human_guess
      print "Enter your guess: "
      guess_input = gets.chomp.split(", ")
      unless valid_input?(guess_input)
        puts "Invalid input. Please enter a valid color using the colors #{COLORS}."
        return human_guess
      end
      guess_input
    end

    def generate_all_mastermind_combinations
      COLORS.repeated_permutation(4).to_a
    end

    def computer_guess
      sleep(0.7)
      possible_combinations = generate_all_mastermind_combinations
      guess = [COLORS[0], COLORS[0], COLORS[1], COLORS[1]]
      result = evaluate_guess(@secret_code, guess)
      possible_combinations.select! do |value|
        guess_result = evaluate_guess(value, guess)
        guess_result[0] == result[0] && guess_result[1] == result[1]
      end
      guess = possible_combinations.sample
    end

    def valid_input?(input)
      return false if input.length != 4
      input.each do |color|
        return false unless COLORS.include?(color)
      end
      return true
    end

    def evaluate_guess(secret_array, guess)
      copy_of_guess = guess.dup
      color_matches = 0
      exact_matches = 0
      secret_array.each_with_index do |value, i|
        exact_matches += 1 if value == guess[i]
      end
      secret_array.each do |value|
        i = copy_of_guess.find_index(value)
        color_matches += 1 unless i.nil?
        copy_of_guess.delete_at(i) unless i.nil?
      end
      [exact_matches, color_matches]
    end

    def display_board(guess, exact_matches, color_matches)
      puts "\nTurn #{@turn}: #{guess}   Exact Matches: #{exact_matches}   Color Matches: #{color_matches}"
    end

    def self.replay?
      puts "\nWanna Play Again? (\"Yes\" for continue, \"No\" for stop)"
      answer = gets.chomp.downcase
      return true if answer == "yes"
      nil
    end
  end
end

include MasterMind
ready = false
until ready
  system "clear"
  Game.new.play
  ready = true unless Game.replay?
end

puts "\n-----------------------------------"
puts "Goodbye, have a good day with Odin!"
puts "\n-----------------------------------"

