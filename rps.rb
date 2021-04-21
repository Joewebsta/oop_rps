module Formatable
  def spacer
    puts
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors']

  def initialize(value)
    @value = value
  end

  def scissors?
    @value == 'scissors'
  end

  def rock?
    @value == 'rock'
  end

  def paper?
    @value == 'paper'
  end

  def >(other_move)
    (rock? && other_move.scissors?) ||
      (paper? && other_move.rock?) ||
      (scissors? && other_move.paper?)
  end

  def <(other_move)
    (rock? && other_move.paper?) ||
      (paper? && other_move.scissors?) ||
      (scissors? && other_move.rock?)
  end

  def to_s
    @value
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end
end

class Human < Player
  include Formatable

  def set_name
    n = ""
    loop do
      spacer
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, must enter a value."
    end
    self.name = n
  end

  def choose
    choice = nil

    loop do
      spacer
      puts "Please choose rock, paper, or scissors:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end

    system "clear"
    self.move = Move.new(choice)
  end
end

class Computer < Player
  def set_name
    self.name = ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5'].sample
  end

  def choose
    self.move = Move.new(Move::VALUES.sample)
  end
end

class RPSGame
  include Formatable
  WINNING_SCORE = 10

  attr_accessor :human, :computer

  def initialize
    @human = Human.new
    @computer = Computer.new
  end

  def display_welcome_message
    spacer
    puts "***** Welcome to Rock, Paper, Scissors! *****"
    puts "The first player to score #{WINNING_SCORE} points wins"
  end

  def display_goodbye_message
    spacer
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "----------------RESULTS----------------"
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    if human.move > computer.move
      human.score += 1
    else
      computer.score += 1
    end

    spacer
    puts "-----------------SCORE-----------------"
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.name}'s score: #{computer.score}"
  end

  def winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def game_over_message
    if human.score == WINNING_SCORE
      winner = human.name
    elsif computer.score == WINNING_SCORE
      winner = computer.name
    end

    spacer
    puts "----------------WINNER-----------------"
    puts "#{winner} is the first to #{WINNING_SCORE} points and wins the game!"
  end

  def play_again?
    answer = ''

    loop do
      spacer
      puts "--------------PLAY AGAIN?--------------"
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def play_game
    loop do
      human.choose
      computer.choose
      display_moves
      display_winner
      display_score

      if winner?
        game_over_message
        break
      end
    end
  end

  def play
    display_welcome_message

    loop do
      play_game
      break unless play_again?
      reset_scores
    end

    display_goodbye_message
  end
end

RPSGame.new.play
