class Game

  def initialize()
    @random_number2 = 0
    @random_number1 = 0
    @correct_answer = 0
    @level_counter = 0
    @players = []
  end

  def strike
    100.round(2) / timer
  end
  
  def new_game
    puts "Round 1"
    @current_target = @players[0]
    @current_player = @players[1]
    next_level
  end

  def whos_turn
    if @level_counter % 2 == 0 
      @current_player = @players[1]
      @current_target = @players[0]
    else
      @current_player = @players[0]
      @current_target = @players[1]
    end
  end

  def the_question  
    @random_number2 = rand(2 + @level_counter) + @level_counter
    @random_number1 = rand(2 + @level_counter) + @level_counter
    @correct_answer = @random_number1 + @random_number2
  end
  
  def next_level
    @level_counter += 1
    
    whos_turn
    the_question
    display_question
    player_attempt
  end

  def display_question
  display_life
  puts   
  puts "#{@current_player.name}"
  print "Press Enter when ready "
  gets.chomp
  timer_start
  print "#{@random_number1} + #{@random_number2} = ?? "
  player_attempt
  end

  def player_attempt
  timer_start
  player_answer = gets.chomp.to_i
  is_correct(player_answer)
  end

  def is_correct(player_answer)
    timer_end
    if player_answer == @correct_answer    
      puts "successful strike of #{@random_number1} + #{@random_number2} in #{timer} seconds.."
      player_hit
    else
      player_block
    end
  end

  def player_hit
    @current_player.strike = strike
    power_scale
    next_level
  end

  def power_scale
    if @level_counter % 2 == 0
      if @current_target.strike > @current_player.strike
        @current_player.health -= @current_target.strike - @current_player.strike
        puts "#{@current_player.name} takes #{(@current_target.strike - @current_player.strike).round(0)} damage"
      else
        @current_target.health -= @current_player.strike - @current_target.strike
        puts "#{@current_target.name} takes #{(@current_player.strike - @current_target.strike).round(0)} damage"
      end
      if @current_target.health < 0 || @current_player.health < 0
        round_over
      else
        next_level
      end
      next_level
    end
    next_level
  end
  

  def player_block
    puts "#{@current_target.name} blocks #{@current_player.name}'s attack"
    power_scale
  end

  def round_over
    if @current_player.score > 2
      puts "#{@current_player.name} wins"
    elsif @current_player.score == 1 || @current_target.score == 1
      puts "Round 3"
      @current_player.score += 1
    else
      puts "Round 2"
      @current_player.score += 1
    end
    new_round
  end

  def new_round
    @level_counter = 0
    @players[0].health = 100
    @players[1].health = 100
    next_level
  end
  def display_life
    puts "#{@players[0].name} : #{@players[0].health.round(0)} / #{@players[0].life}   Round Wins: #{@players[0].score} "
    puts "#{@players[1].name} : #{@players[1].health.round(0)} / #{@players[1].life}   Round Wins: #{@players[1].score} "
  end


  def welcome
  puts "++ ============================================= ++" 
  puts "|                   Math Fighter 2                |"
  puts "++ ============================================= ++"

  print "Player 1 enter your username: "
  @players.push(Player.new(gets.chomp))
  print "Player 2 enter your username: "
  @players.push(Player.new(gets.chomp))

  new_game
  end

  def time_left
    time = timer_limit()-timer()
  end

  def timer
    time = @level_timer_end - @level_timer_start.round(2)
  end

  def timer_start
    @level_timer_start = Time.now.round(2)
  end

  def timer_end
    @level_timer_end = Time.now.round(2)
  end

end

class Player
  attr_accessor :health,:score,:name,:life,:strike
  def initialize(name, health = 100, score = 0, life =100)
    @name = name
    @health = health
    @life = life
    @score = score
    @strike = 0
  end
end

game = Game.new
game.welcome