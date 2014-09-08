require 'pry'
#badass
class Game
  def initialize()
    @random_number2 = 0
    @random_number1 = 0
    @correct_answer = 0
    @level_counter = 0
    @players = []
    @attack_mode_is = ""
    @last_level_champion = nil
    @last_level_victim = nil
    @winner_counter = 1
  end

  #creates player class objects by using @players.push 
  #@players[0] will have player1 object @players[1] will have player2 object
  #Player.new is taking user input as an argument 
  #see the Player class to see how players are born
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

  #the current_player is Player1 current_target is Player2
  #they are being assigned in the wrong order to start with  
  def new_game
    puts "                                   Round 1 - FIGHT"
    @current_target = @players[0]
    @current_player = @players[1]
    @last_level_champion = @current_player
    @last_level_victim = @current_target
    next_level
  end

  #whos_turn() switches the players using @level_counter % 2 == 0 
  #@level_counter is used to increase difficulty aswell
  #the_question() is generating the users question using rand()
  #display_question() displays question
  #player_attempt takes the user answer
  def next_level
    whos_turn
    @level_counter += 1
    display_life if @level_counter % 2 != 0
    display_question
    player_attempt
  end

  #whos_turn() keeps track of whos turn it should be
  #constantly switching @current_player and @current_target after each turn
  #needs to be cleaned up
  def whos_turn
    @winner_counter += 1
    if @winner_counter % 2 == 0  
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

  #the_question(input) takes user input from attack menu  
  #the_question(input) assigns @current_player.attack_mode_is and calls attack method
  #needs to be cleaned up
  def the_question(attack)
    @current_player.attacks = @current_player.attack[attack-1]
    @attack_mode_is = @current_player.attacks
    
    case attack_mode(@attack_mode_is)
    when "fireball"
      @current_player.attack_mode_is = "fireball"
      fireball_attack
    when "uppercut"
      @current_player.attack_mode_is = "uppercut"
      uppercut_attack
    when "spam"
      @current_player.attack_mode_is = "spam"
      spam_attack
    when "piledriver"
      @current_player.attack_mode_is = "piledriver"
      piledriver_attack
    when "downup"
      @current_player.attack_mode_is = "downup"
      downup_attack
    when "backforward"
      @current_player.attack_mode_is = "backforward"
      downforward_attack
    when "punch"
      @current_player.attack_mode_is = "punch"
      punch_attack
    when "kick"
      @current_player.attack_mode_is = "kick"
      kick_attack
    end
  end

  #displays @current_player attack methods
  def attack_select
    moves_count = @current_player.attack.size
    count = 1
    puts
    puts "#{@current_player.name} Move List:"
    moves_count.times do |n|
      puts "#{count}. #{@current_player.attack[n]}"
      count +=1
    end
  end

  def attack_mode(userinput)
    case userinput
    when "Hadoken", "Yoga Fire"
       return "fireball"
    when "Shoryuken", "Yoga Flame"
      return "uppercut"
    when "Hundred Hand Slap","Lightning Kick","Electric Thunder"
      return "spam"
    when "Spinning Bird Kick","Flash Kick"
      return "downup"
    when "Sumo Headbutt","Rolling Attack","Sonic Boom"
      return "backforward"
    when "Spinning Piledriver"
      return "piledriver"
    when "Punch"
      return "punch"
    when "Kick"
      return "kick"
    end
  end

  #needs dynamic health bars
  #needs more street fighter 2 
  def display_life
    puts "#{@players[0].name}       #{@players[0].health.round(0)} / #{@players[0].life}      V: #{@players[0].score}" \
      "         Time: #{@level_counter}         V: #{@players[1].score}      #{@players[1].health.round(0)} / #{@players[1].life}       #{@players[1].name} "
    puts "******                                   VS                                     ******" 
  end

  #the game waits for user to press enter so the #timer can start when player is ready
  def display_question
  attack_select
  print "                            #{@current_player_user}. #{@current_player.name} chose attack when ready: "
  attack = gets.chomp.to_i
  the_question(attack)
  print "                                       #{@random_number1} #{@opperator} #{@random_number2} = "
  player_attempt
  end

  #starting the timer right before the player_answer gets
  def player_attempt
  timer_start
  @current_player.attack_mode_is == "spam" ? player_answer = gets.chomp : player_answer = gets.chomp.to_i
  is_correct(player_answer)
  end

  #if the player answers correct player_hit() is called
  #if the player is wrong player_block() is called
  def is_correct(player_answer)
    timer_end
    if player_answer == @correct_answer    
      player_hit
    else
      player_block
    end
  end

  #player_hit() asigns @current_player.strike using #strike() method
  #@current_player.strike is the damage 
  def player_hit
    @current_player.strike = strike
    puts "                    #{@current_player.name} attacks with #{@current_player.attacks} of #{@current_player.strike.round(0)} in #{timer} seconds.."
    power_scale
    next_level
  end

  #player_block() makes @current_player.strike harmless
  #users attack is blocked
  def player_block
    @current_player.strike = 0
    puts "                           #{@current_target.name} blocks #{@current_player.name}'s attack"
    power_scale
  end

  #power_scale method is called every round but...
  #power_scale only runs after both players take a turn
  #calculate who takes damage by comparing results of @current_player and @current_targets strike 
  #if #health is 0 #round_over() is called 
  #TODO:
  #power_scale compares @current_player.attacks vs @current_target.attacks and apply Street Fighter logic
  #ex jump vs fireball, fireball vs block ect..
  def power_scale
    if @level_counter % 2 == 0
      if @current_target.strike > @current_player.strike
        @current_player.health -= @current_target.strike - @current_player.strike
        puts "                                  #{@current_player.name} takes #{(@current_target.strike - @current_player.strike).round(0)} damage"
      else
        @current_target.health -= @current_player.strike - @current_target.strike
        puts "                                  #{@current_target.name} takes #{(@current_player.strike - @current_target.strike).round(0)} damage"
        whos_turn
      end
      if @current_target.health < 0 || @current_player.health < 0
        puts "                                           KO"
        puts "                                         *******"
        round_over
      else
        next_level
      end
      next_level
    end
    next_level
  end

  #ternary operator checks whos knocked out, gives a point to the winner.
  #if score is >=2 its game over
  #if score is 1-1 its round 3 
  #else its round 2
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
        puts "                                    ***** Round 3 ******"
        puts
      else
        puts
        puts "                                    ***** Round 2 ******"
        puts
      end
    new_round
  end

  #new_round is called after #round_over 
  #new_round() heals the players and turns back time 
  def new_round
    @level_counter = 0
    @players[0].health = 100
    @players[1].health = 100
    next_level
  end

  #strike() is called to calculate how powerful the attack will be
  def strike
    100 / timer() * @current_player_strike_mod
  end

  #timer logic
  def timer
    time = @level_timer_end - @level_timer_start.round(2)
  end

  def timer_start
    @level_timer_start = Time.now.round(2)
  end

  def timer_end
    @level_timer_end = Time.now.round(2)
  end

  #SPECIAL MOVES (should be in player class?)
  ## fireball question logic to be added here
  def random_generator(start,stop)
    rand(start..stop)+1
  end

  def fireball_attack
    @random_number2 = random_generator(1,19)
    @random_number1 = random_generator(1,19)
    @opperator = "+"
    @current_player_strike_mod = 1.4
    @correct_answer = @random_number1 + @random_number2
  end 
  ## uppercut question logic to be added here
  def uppercut_attack
    @random_number2 = random_generator(6,8)
    @random_number1 = random_generator(6,8)
    @opperator = "X"
    @current_player_strike_mod = 1.6
    @correct_answer = @random_number1 * @random_number2
  end 
  ## lightning kick, hundread hand slap, electric thunder question logic added here
  def spam_attack
    @random_number2 = random_generator(1,4)
    @random_number1 = random_generator(1,4)
    @opperator = "+"
    @current_player_strike_mod = 1.3
    correct_number = @random_number1 + @random_number2
    @correct_answer = ""
    correct_number.times do |n|
      @correct_answer += "p"      
    end
    @current_player_att
    puts "Press the 'p' key this many times:"
    puts @correct_answer.inspect
  end 
  ## imposible spining piledriver question here
  def piledriver_attack

  end
  ## spinning bird kick, flash kick 
  def downup_attack

  end
  ## sonic boom, rolling attack, sumo headbutt
  def backforward_attack
  
  end
  ## pucnch attack
  def punch_attack
    @random_number1 = random_generator(1,9)
    @random_number2 = random_generator(1,4)
    @opperator = "+"
    @current_player_strike_mod = 1
    @correct_answer = @random_number1 + @random_number2
  end

  ## kick attack
  def kick_attack
    @random_number1 = random_generator(1,9)
    @random_number2 = random_generator(1,4)
    @opperator = "-"
    @current_player_strike_mod = 1.2
    @correct_answer = @random_number1 - @random_number2  
  end

  ## throw attack
  def throw_attack

  end
  ## jump attack
  def jump_attack

  end
  ## block attack
  def block_attack

  end
end

#player objects are created using Player class. 
#bob = Player.new(1) will create:
#bob.fighter = "Ryu"
#bob.health = 100
#bob.life = 100
#bob.score = 0
#bob.strike = 0
#bob.attack = ["Hadoken","Shoryuken","Hurricane Kick"]
class Player
  #connected to Game class using attr_accessor
  #pro-tip: attr_accessor :name will create @name in #initialize
  attr_accessor :health,:score,:name,:life,:strike,:attack,:attacks, :attack_mode_is
  def initialize(input, health = 100, score = 0, life =100)
    @fighter = ""
    @health = health
    @life = life
    @score = score
    @strike = 0
    @attack = fighter_select(input)
    @attacks = @attack
    @attack_mode_is = ""
  end

  #@attack is created by Player.initialize
  #@attack calls #fighter_select(input) method upon initialization
  #fighter_select(input) assigns @attack and @name  
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
        @attack = ["Hundred Hand Slap","Sumo Headbutt"]
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
        @attack = ["Sonic Boom", "Flash Kick"]
      when 8
        @name = "Dhalsim"
        @attack = ["Yoga Fire","Yoga Flame"]
      else
        error
    end
    @attack.push("Punch","Kick","Throw","Block","Jump")
  end
  
  def error
    "CRASH!!!"
    welcome 
  end



end


game = Game.new
game.welcome