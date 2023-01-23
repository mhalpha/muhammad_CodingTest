require 'json'

class Player
  attr_accessor :name, :account, :properties, :position

  def initialize(name, account, properties, position)
    @name = name
    @account = account
    @properties = properties
    @position = position
  end
end

class Property
  attr_accessor :name, :owner

  def initialize(name, owner)
    @name = name
    @owner = owner
  end
end

class Game
  require 'json'

  # Players

  player1 = Player.new('Peter', 16, [''], 0)
  player2 = Player.new('Billy', 16, [''], 0)
  player3 = Player.new('Charlotte', 16, [''], 0)
  player4 = Player.new('Sweedal', 16, [''], 0)

  players = [player1, player2, player3, player4]

  # Dice and Board Json load

  rolls_1 = File.read('rolls_1.json')
  rolls_2 = File.read('rolls_2.json')
  board = File.read('board.json')

  # Dice and Board Json Parse

  rolls1 = JSON.parse(rolls_1)
  rolls2 = JSON.parse(rolls_2)
  
  boardPlay = JSON.parse(board)
  #puts boardPlay[0]

  properties = []
  boardPlay.each do |_i|
    properties.push(Property.new(_i['name'], ''))
  end

  #puts properties.length()

  puts "\nWelcome to Woven Monopoly"
  puts "__________________________________"
  puts "\n"

  #initializing length of dice and player arrays
  dice_length = rolls2.length
  player_length = players.length

  diceIndex = 0
  playerIndex = 0

  while diceIndex < dice_length
    
      $cost = 0
    
    if playerIndex < player_length
      puts "Player Name: #{players[playerIndex].name}"
      puts "Money in Account: #{players[playerIndex].account}"

      diceValue = rolls2[diceIndex]
      #puts diceValue
      #puts players[playerIndex].position

      #Initializing the player position to 0 after reaching the limit of board
      if players[playerIndex].position > properties.length() - 1
        players[playerIndex].position = 0
      end

      #storing the current position and dice value
      added_diceValue = diceValue + players[playerIndex].position
      #puts added_diceValue

      if added_diceValue > properties.length() - 1
        added_diceValue = added_diceValue - properties.length() + 1
        players[playerIndex].account += 1
        
      end 
      bd = boardPlay[added_diceValue]

      #Adding the cost of property
      $cost += boardPlay[added_diceValue]['price']
      #Adding the current value of dice in player's position
      players[playerIndex].position += diceValue

      #Checking if the property is owned by a player
      if properties[added_diceValue].owner != ''
        owner = properties[added_diceValue].owner

        #Adding the cost of property in player's account
        players[owner].account += $cost
        #Renting the cost of property in owner's account
        players[playerIndex].account -= $cost

        #Games finishes if any player is bankrupt
        if players[playerIndex].account <= 0
          puts "Player lost due to no money in account"
          break
        end 

        puts "Rent paid to: #{players[owner].name}"
      else
        properties[added_diceValue].owner = playerIndex

        #pushing the property to player's property list
        players[playerIndex].properties.push(bd)

        players[playerIndex].account -= $cost

      end
      
      print 'Properties Owned'
      puts players[playerIndex].properties
      puts "Money Left in account: #{players[playerIndex].account}"

      playerIndex += 1
      playerIndex = 0 if playerIndex == player_length

    end

    diceIndex += 1

    # puts players[0].name

    puts "\nPress Enter to roll dice for the next player"
    a = gets.chomp
    break if a == 'n'
  end

  puts "__________________________________"
  puts "Final Result"
  players.each do |_k|
    puts "Player: #{_k.name} with #{_k.account}"
  end
end
