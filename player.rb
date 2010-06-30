module Onzie
  class Player
    def initialize(table, name)
      @hand = []
      @score = 0
      @table = table
      @name = name
    end
    attr_accessor :hand, :score, :table, :name

    def draw(deck)
      @hand.unshift(deck.draw)
    end

    def take(card_indexes)
      cards_taken_from_hand = card_indexes.map {|i| @hand[i]}
      cards_taken_from_hand.each {|c| @hand.delete(c)}
    end

    def discard(card_index, discard_pile)
      discard_pile << take(card_index)
    end

    def lay_down(card_indexes)
      cards = take(card_indexes)
      @table.place(@name,cards)
    end

    def score_hand
      self.hand.each do |c|
        self.score += c.points
      end
    end
    
  end
end
