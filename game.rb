require "player"
require "deck"
require "table"

module Onzie
  class Game
    def initialize(*player_names)
      @table = Table.new
      @players = {}
      player_names.each do |p|
        @players[p] = Player.new(@table, p)
      end
      
      @deck = Deck.new
      @discard_pile = DiscardPile.new
      @hand_number = 1
    end
    attr_accessor :players, :deck, :discard_pile, :table

    def deal(number)
      @players.each do |n,p|
        p.hand = @deck.draw(number)
      end
      @discard_pile.cards << @deck.draw
    end

    def cards_in_hand
      {1 => 7, 2 => 8, 3 => 9, 4 => 10, 5 => 11, 6 => 12, 7 => 12}
    end
  end
end
