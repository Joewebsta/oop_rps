module Formatable
  def spacer
    puts
  end
end

class Rock
  def >(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Spock || other_move.class == Paper
  end
end

class Paper
  def >(other_move)
    other_move.class == Rock || other_move.class == Spock
  end

  def <(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end
end

class Scissors
  def >(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Spock
  end
end

class Spock
  def >(other_move)
    other_move.class == Rock || other_move.class == Scissors
  end

  def <(other_move)
    other_move.class == Lizard || other_move.class == Paper
  end
end

class Lizard
  def >(other_move)
    other_move.class == Paper || other_move.class == Spock
  end

  def <(other_move)
    other_move.class == Rock || other_move.class == Scissors
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_accessor :type

  def initialize(value)
    @value = value
    @type = set_type
  end

  def set_type
    case @value
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
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
      puts "Please choose rock, paper, scissors, spock or lizard:"
      choice = gets.chomp
      break if Move::VALUES.include?(choice)
      spacer
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
    puts "***** Welcome to Rock, Paper, Scissors, Spock, Lizard! *****"
    puts "The first player to score #{WINNING_SCORE} points wins"
  end

  def display_goodbye_message
    spacer
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Good bye!"
    spacer
  end

  def display_moves
    puts "----------------RESULTS----------------"
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}."
  end

  def display_winner
    if human.move.type > computer.move.type
      puts "#{human.name} won!"
    elsif human.move.type < computer.move.type
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if human.move.type > computer.move.type
      human.score += 1
    elsif human.move.type < computer.move.type
      computer.score += 1
    end
  end

  def display_score
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
      computer.choose
      human.choose
      display_moves
      display_winner
      update_score
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
