# Required by Game

class Card
  attr_accessor :face, :suit

  def initialize(face, suit)
    @face = face
    @suit = suit
  end

  def name
    "#{face} of #{suit}"
  end

  def self.faces
    %w(Ace 2 3 4 5 6 7 8 9 10 Jack Queen King)
  end

  def self.suites
    %w(Clubs Diamonds Hearts Spades)
  end

end
