require 'irb'
require_relative 'card'
require_relative 'deck'
# require_relative 'player'
# require_relative 'dealer'

class Game
  attr_accessor :deck

  def initialize(player_piggybank)                                              # I am passing my $100 as a parameter
    @deck, @player_hand, @dealer_hand = Deck.new, Array.new, Array.new          # initial values for @variables
    @player_piggybank = player_piggybank
    @bet = 10
    print dealer_says[:piggybank]
    deal_hands                                                                  # start dealing, and start player turn right away
    player_turn
  end

  def deal_hands
    deal_card_into(@player_hand)
    deal_card_into(@dealer_hand)
    deal_card_into(@player_hand)
    deal_card_into(@dealer_hand)

    print "One of the two Dealer cards is #{@dealer_hand.sample(1)[0].name}. \n"
  end

  def player_turn
    @player_hand_value = hand_value_of(@player_hand)                            # list all cards in player's hand and put them in a readable format, not just an array
    print "Your cards are: #{ @player_hand.map{|card| card.name}.join(', ') }. The total is #{ @player_hand_value }. \n"

    case
    when @player_hand_value > 21
      print @dealer_says[:busted]
      @player_piggybank -= 10
      play_again?
    when @player_hand_value == 21
      print @dealer_says[:blackjack]
      @player_piggybank += 20
      play_again?
    when @player_hand_value < 21                                                # I am using recursion to 'loop' and 'fall' through the cases until I bust, get blackjack, or decide to hit no [but I think ruby doesn't actually let it fall through, like other languages do]
      hit_or_stand?
      if @answer == "h"
        deal_card_into(@player_hand)
        player_turn
      else
        print @dealer_says[:dealer_turn]
        dealer_turn
      end
    end
  end

  def dealer_turn                                                               # at this point, I am calling the dealer_turn method while player stayed at < 21 points
    dealer_hand_value = hand_value_of(@dealer_hand)
    print "Dealer has: #{ @dealer_hand.map{|card| card.name}.join(', ') }. The total is #{ dealer_hand_value }. \n"

    case
    when dealer_hand_value > 21
      print @dealer_says[:win]
      @player_piggybank += 20
      play_again?
    when dealer_hand_value == 21
      print @dealer_says[:dealer_blackjack]
      @player_piggybank -= 10
      play_again?
    when @player_hand_value < dealer_hand_value
      print @dealer_says[:dealer_win]
      @player_piggybank -= 10
      play_again?
    else                                                                         # recursion again; this will make the Dealer just keep drawing until matching one of the 3 switch cases
      print @dealer_says[:dealer_draw]
      deal_card_into(@dealer_hand)
      dealer_turn
    end
  end



# =================================================================================================
protected

# this should work ... just look don't touch
  def deal_card_into(hand)
    hand << @deck.cards.pop(1)
    hand.flatten!
  end


# this should work ... just look, don't touch
  def hit_or_stand?                                                              # this is basically copy-pasted from Newline
    while true
      print "Do you want to (h)it or (s)tand?  "
      @answer = answer = gets.chomp.downcase
      if answer == "h"
        break true
      elsif answer == "s"
        break false
      end
      print "That is not a valid answer! \n"
    end
  end


  def play_again?
    while true
      print "Would you like to play Blackjack again? (y)es/(n)o: "
      answer = gets.chomp.downcase
      if answer == "y" && @player_piggybank >=10
        print @dealer_says[:new_game]
        return Game.new(@player_piggybank)
      elsif answer == "n" || @player_piggybank < 10
        print @dealer_says[:goodbye]
        return false
      end
      puts "That is not a valid answer!"
    end
    exit                                                                        # EXIT EXIT EXIT OUT OF THE GAME ALTOGETHER
  end


# this should work ... just look, don't touch
  def hand_value_of(hand)
    ace_value_one_bucket, ace_value_eleven_bucket = 0, 0

    hand.each do |card|
      if card.face == "Ace"
        ace_value_one_bucket += 1
        ace_value_eleven_bucket += 11
      elsif card.face == "Jack" || card.face == "Queen" || card.face == "King"
        ace_value_one_bucket += 10
        ace_value_eleven_bucket += 10
      else
        ace_value_one_bucket += card.face.to_i
        ace_value_eleven_bucket += card.face.to_i
      end
    end

    if ace_value_one_bucket < ace_value_eleven_bucket && ace_value_eleven_bucket <= 21
      ace_value_eleven_bucket
    else
      ace_value_one_bucket
    end
  end

# there should be a better way to do this
  def dealer_says
    @dealer_says = {
    # :intro => "Dealer has #{@dealer_hand.sample(1)[0].name}. \n",
    # :player_has => "Your cards are: #{ @player_hand.map{|card| card.name}.join(', ') }. The total is #{ @player_hand_value }. \n",
    :piggybank => "\nYou currently have $#{@player_piggybank} and you are betting $#{@bet}. \n",
    :busted => "Busted. You lost the $#{@bet} that I made you give me. \n",
    :win => "You win! You get $#{@bet} back and $10 from me. \n",
    :blackjack => "Blackjack! You get $#{@bet} and $10 from me. \n",
    :dealer_draw => "Dealer drew a card. \n",
    # :dealer_has => "Dealer has: #{ @dealer_hand.map{|card| card.name}.join(', ') }. The total is #{ @dealer_hand_value }. \n",
    :dealer_blackjack => "Dealer's Blackjack! You lost $#{@bet}. \n",
    :dealer_win => "Dealer wins. \n",
    :new_game => "New Round! \n",
    :goodbye => "Goodbye! Next time have more patience or money!!! \n",
    }
  end

end
# this is the last end, end end, end, period.



print "Welcome to the game of Blackjack! \n\nThere are 2 rules: \n   You start with $100 and bet $10 each round. \n   Aces have a value of 1 or 10. \n\nLet's start! \n"
Game.new(100)                                                                   # I am passing my $100 as a parameter

binding
