module Formatable
  def spacer
    puts
  end
end

class Player
  attr_accessor :score, :name, :move

  private

  def initialize
    @score = 0
  end

  def create_move(choice)
    case choice
    when 'rock' then Rock.new
    when 'paper' then Paper.new
    when 'scissors' then Scissors.new
    when 'lizard' then Lizard.new
    when 'spock' then Spock.new
    end
  end
end

class Human < Player
  include Formatable

  def initialize
    super
    set_name
  end

  def choose
    choice = convert_abbrev(select_move)
    system "clear"
    self.move = create_move(choice)
  end

  private

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

  def convert_abbrev(move)
    return move if move.size > 2

    case move
    when 'r' then 'rock'
    when 'p' then 'paper'
    when 'sc' then 'scissors'
    when 'l' then 'lizard'
    when 'sp' then 'spock'
    end
  end

  def select_move
    choice = nil

    loop do
      spacer
      move_prompt
      choice = gets.chomp.downcase
      break if Move::VALUES.include?(choice)
      spacer
      puts "Sorry, invalid choice."
    end

    choice
  end
end

def move_prompt
  puts "Please choose rock(r), paper(p), scissors(sc), spock(sp) or " \
           "lizard(l):"
end

class Computer < Player
  attr_reader :personality

  def initialize
    super
    set_personality
  end

  private

  attr_writer :personality

  def set_personality
    self.personality = [R2D2, Hal, Chappie, Sonny, Number5].sample.new
  end
end

class R2D2 < Computer
  def initialize
    @name = "R2D2"
  end

  def choose
    self.move = create_move("rock")
  end
end

class Hal < Computer
  def initialize
    @name = "Hal"
  end

  def choose
    choice = rand(1..10) < 9 ? 'scissors' : "rock"
    self.move = create_move(choice)
  end
end

class Chappie < Computer
  def initialize
    @name = "Chappie"
  end

  def choose
    choice = case rand(1..20)
             when (1..10) then "lizard"
             when (11..15) then "spock"
             when (16..18) then "rock"
             else "paper"
             end

    self.move = create_move(choice)
  end
end

class Sonny < Computer
  def initialize
    @name = "Sonny"
  end

  def choose
    self.move = create_move(["rock", "spock"].sample)
  end
end

class Number5 < Computer
  def initialize
    @name = "Number 5"
  end

  def choose
    self.move = create_move('lizard')
  end
end

class Move
  VALUES = ['rock', 'r', 'paper', 'p', 'scissors', 'sc', 'lizard', 'l',
            'spock', 'sp']

  def >(other_move)
    winning_moves.include?(other_move.class)
  end

  def to_s
    @name
  end

  private

  attr_reader :winning_moves
end

class Rock < Move
  def initialize
    @name = "rock"
    @winning_moves = [Scissors, Lizard]
  end
end

class Paper < Move
  def initialize
    @name = "paper"
    @winning_moves = [Rock, Spock]
  end
end

class Scissors < Move
  def initialize
    @name = "scissors"
    @winning_moves = [Paper, Lizard]
  end
end

class Spock < Move
  def initialize
    @name = "spock"
    @winning_moves = [Rock, Scissors]
  end
end

class Lizard < Move
  def initialize
    @name = "lizard"
    @winning_moves = [Paper, Spock]
  end
end

class History
  include Formatable

  def display
    data.each do |round, data|
      print_round(round)
      spacer
      print_results(data)
      spacer
      print_scores(data)
    end
  end

  def view?
    answer = ''

    loop do
      spacer
      puts "-------------VIEW HISTORY?-------------"
      puts "Would you like to view the game history? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def reset
    @data = {}
  end

  def update(human, computer, winner, round)
    winner ||= "tie"

    data[round] = {
      "results" => results(human, computer, winner),
      "score" => score(human, computer)
    }
  end

  private

  attr_reader :data

  def initialize
    @data = {}
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
end

class RPSGame
  include Formatable

  WINNING_SCORE = 10

  def play
    display_welcome_message

    loop do
      play_game
      history.display if history.view?
      history.reset
      break unless play_again?
      reset_scores
      reset_round
    end

    display_goodbye_message
  end

  private

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
    puts "The first player to score #{RPSGame::WINNING_SCORE} points wins"
  end

  def play_game
    loop do
      play_round
      end_of_round_updates

      if game_winner?
        game_over_message
        break
      end
    end
  end

  def play_round
    computer.personality.choose
    human.choose
    display_moves
    determine_winner
    display_winner
  end

  def end_of_round_updates
    update_score
    display_score
    history.update(human, computer, winner, round)
    update_round
  end

  def display_moves
    puts "----------------RESULTS----------------"
    puts "** Round #{round} **"
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.personality.name} chose #{computer.personality.move}."
  end

  def determine_winner
    human_move = human.move
    computer_move = computer.personality.move

    self.winner = if human_move > computer_move
                    human.name
                  elsif human_move.class == computer_move.class
                    nil
                  else
                    computer.personality.name
                  end
  end

  def display_goodbye_message
    spacer
    puts "Thanks for playing Rock, Paper, Scissors, Spock, Lizard. Good bye!"
    spacer
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

  def update_round
    @round += 1
  end

  def game_winner?
    human.score == WINNING_SCORE || computer.score == WINNING_SCORE
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
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Sorry, must be y or n."
    end

    answer == 'y'
  end

  def reset_scores
    human.score = 0
    computer.score = 0
  end

  def reset_round
    self.round = 1
  end
end

RPSGame.new.play
