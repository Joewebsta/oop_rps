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
  end
end

class Human < Player
  include Formatable

  def initialize
    super
    set_name
  end

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
    choice = select_move
    system "clear"
    self.move = Move.new(choice)
  end
end

def select_move
  choice = nil
  loop do
    spacer
    puts "Please choose rock, paper, scissors, spock or lizard:"
    choice = gets.chomp
    break if Move::VALUES.include?(choice)
    spacer
    puts "Sorry, invalid choice."
  end

  choice
end

class Computer < Player
  attr_accessor :personality

  def initialize
    super
    set_personality
  end

  def set_personality
    self.personality = [R2D2.new].sample
    # ['R2D2', 'Hal', 'Chappie', 'Sonny', 'Number 5']
  end
end

class R2D2 < Computer
  def initialize
    @name = "R2D2"
  end

  def choose
    self.move = Move.new("rock")
  end
end

class History
  include Formatable

  attr_reader :data

  def initialize
    @data = {}
  end

  def update(human, computer, winner, round)
    winner ||= "tie"

    data[round] = {
      "results" => results(human, computer, winner),
      "score" => score(human, computer)
    }
  end

  def results(human, computer, winner)
    {
      human.name => human.move.to_s,
      computer.personality.name => computer.personality.move.to_s,
      "Winner" => winner
    }
  end

  def score(human, computer)
    {
      human.name => human.score,
      computer.personality.name => computer.score
    }
  end

  def display
    data.each do |round, data|
      print_round(round)
      spacer
      print_results(data)
      spacer
      print_scores(data)
    end
  end

  def print_round(round)
    puts "------------------------------"
    puts "ROUND #{round}:"
  end

  def print_results(data)
    puts "** Results **"
    data["results"].each do |name, move|
      puts "#{name}: #{move}"
    end
  end

  def print_scores(data)
    puts "** Score **"
    data["score"].each do |name, score|
      puts "#{name}: #{score}"
    end
  end

  def view?
    answer = ''

    loop do
      spacer
      puts "-------------VIEW HISTORY?-------------"
      puts "Would you like to view the game history (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include?(answer.downcase)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end
end

class RPSGame
  include Formatable
  WINNING_SCORE = 3

  attr_accessor :human, :computer, :round, :winner
  attr_reader :history

  def initialize
    @round = 1
    @human = Human.new
    @computer = Computer.new
    @winner = nil
    @history = History.new
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
    puts "#{computer.personality.name} chose #{computer.personality.move}."
  end

  def determine_winner
    self.winner = if human.move.type > computer.personality.move.type
                    human.name
                  elsif human.move.type < computer.personality.move.type
                    computer.personality.name
                  end
  end

  def display_winner
    if winner
      puts "#{winner} won!"
    else
      puts "It's a tie!"
    end
  end

  def update_score
    if winner == human.name
      human.score += 1
    elsif winner == computer.personality.name
      computer.score += 1
    end
  end

  def display_score
    spacer
    puts "-----------------SCORE-----------------"
    puts "#{human.name}'s score: #{human.score}"
    puts "#{computer.personality.name}'s score: #{computer.score}"
  end

  def game_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def update_round
    self.round += 1
  end

  def game_over_message
    if human.score == WINNING_SCORE
      game_winner = human.name
    elsif computer.score == WINNING_SCORE
      game_winner = computer.personality.name
    end

    spacer
    puts "----------------WINNER-----------------"
    puts "#{game_winner} is the first to #{WINNING_SCORE} points and wins" \
         " the game!"
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
      computer.personality.choose
      human.choose
      display_moves
      determine_winner
      display_winner
      update_score
      display_score
      history.update(human, computer, winner, round)
      update_round

      if game_winner?
        game_over_message
        break
      end
    end
  end

  def play
    display_welcome_message

    loop do
      play_game
      history.display if history.view?
      break unless play_again?
      reset_scores
    end

    display_goodbye_message
  end
end

RPSGame.new.play
