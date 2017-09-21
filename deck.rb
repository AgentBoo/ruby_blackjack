# Required by Game

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    create_deck
    shuffle_cards
  end

  def create_deck
    Card.faces.each{ |face| Card.suites.each{ |suit| cards << Card.new(face, suit) }}     # there are 4 suits for each 13 faced cards
  end

  def shuffle_cards
    cards.shuffle!                                                                        # persistent shuffle
  end


end
