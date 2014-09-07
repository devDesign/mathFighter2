class Game

  def initialize()
    @random_number2 = 0
    @random_number1 = 0
    @correct_answer = 0
    @level_counter = 0
    @players = []
  end

  def welcome
    puts "                                       MATH FIGHTER 2"               
    puts "                                    ******************"
    puts "1.Ryu"
    puts "2.Ken"
    puts "3.E.Honda"
    puts "4.Chun Li"
    puts "5.Blanka"
    puts "6.Zangief"
    puts "7.Guile"
    puts "8.Dhalsim"
    print "1P select fighter: "
    @players.push(Player.new(gets.chomp))
    print "2P select fighter: "
    @players.push(Player.new(gets.chomp))

    new_game
  end

  def new_game
    puts "                                   Round 1 - FIGHT"
    @current_target = @players[0]
    @current_player = @players[1]
    next_level
  end

  def next_level
    whos_turn
    @level_counter += 1
    the_question
    display_life if @level_counter % 2 != 0
    display_question
    player_attempt
  end

  def whos_turn
    if @level_counter % 2 == 0 
      @current_player = @players[0]
      @current_target = @players[1]
      @current_player_user = "P1"
      @current_target_user = "P2"
    else
      @current_player = @players[1]
      @current_target = @players[0]
      @current_player_user = "P2"
      @current_target_user = "P1"
    end
  end

  def the_question  
    @random_number2 = rand(1 + @level_counter) 
    @random_number1 = rand(1 + @level_counter)
    @correct_answer = @random_number1 + @random_number2
  end

  def display_life
    puts "#{@players[0].name}       #{@players[0].health.round(0)} / #{@players[0].life}      V: #{@players[0].score}" \
      "         Time: #{@level_counter}         V: #{@players[1].score}      #{@players[1].health.round(0)} / #{@players[1].life}       #{@players[1].name} "
  end

  def display_question
  print "                            #{@current_player_user}. #{@current_player.name} press ENTER to attack"
  gets.chomp
  print "                                       #{@random_number1} + #{@random_number2} = "
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
      player_hit
    else
      player_block
    end
  end

  def player_hit
    @current_player.strike = strike
    puts "#{@current_player.attack.sample} of #{@current_player.strike.round(0)} in #{timer} seconds.."
    power_scale
    next_level
  end

  def player_block
    @current_player.strike = 0
    puts "#{@current_target.name} blocks #{@current_player.name}'s attack"
    power_scale
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

  def round_over
    @current_player.health > @current_target.health ? @current_player.score += 1 : @current_target.score +=1
    display_life
    if @current_player.score >= 2 || @current_target.score >= 2
      puts "game over"
      puts "Continue? y/n"
      continue = gets.chomp
      if continue == "y"
        initialize
        welcome
      end
      exit
    elsif @current_player.score == 1 && @current_target.score == 1
        puts 
        puts
        puts "                *************************Round 3***************************"
        puts puts
      else
        puts
        puts
        puts "                *************************Round 2***************************"
        puts puts
      end
    new_round
  end

  def new_round
    @level_counter = 0
    @players[0].health = 100
    @players[1].health = 100
    next_level
  end

  def strike
    100 / timer() 
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
  attr_accessor :health,:score,:name,:life,:strike,:attack
  def initialize(name, health = 100, score = 0, life =100)
    @fighter = ""
    @health = health
    @life = life
    @score = score
    @strike = 0
    @attack = fighter_select(name)
  end

  
  def fighter_select(input)
    case input.to_i
      when 1
        @name = "Ryu"
        @attack = ["Hadoken","Shoryuken","Hurricane Kick"]
      when 2
        @name = "Ken"
        @attack = ["Hadoken","Shoryuken","Hurricane Kick"]
      when 3
        @name = "E.Honda" 
        @attack = ["Hundred Hand Slap","Sumo Headbutt","Sumo Smash"]
      when 4
        @name = "Chun Li"
        @attack = ["Lightning Kick","Spinning Bird Kick"]
      when 5
        @name = "Blanka"
        @attack = ["Electric Thunder","Rolling Attack"]
      when 6
        @name = "Zangief"
        @attack = ["Spinning Piledriver"]
      when 7
        @name = "Guile"
        @attack = ["Sonic Boom","Flash Kick"]
      when 8
        @name = "Dhalsim"
        @attack = ["Yoga Fire","Yoga Flame"]
      else
        error
    end
    @attack.push("Punch","Kick","Throw")
  end
  
  def error
    "CRASH!!!"
    game.welcome 
  end
end

game = Game.new
game.welcome