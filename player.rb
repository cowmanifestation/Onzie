module Onzie
  class Player
    def initialize(table, name)
      @cards_in_hand = []
      @score = 0
      @table = table
      @name = name
    end
    attr_accessor :cards_in_hand, :score, :table, :name

    def draw(deck)
      @cards_in_hand.unshift(deck.draw)
    end

    def take(card_indexes)
      cards_taken_from_hand = card_indexes.map {|i| @cards_in_hand[i]}
      card_indexes.reverse.each {|i| @cards_in_hand.delete_at(i)}
      return cards_taken_from_hand
    end

    def discard(discard_pile, card_index)
      discard_pile << take(card_index)
    end

    def lay_down(*collections)
      cards = collections.sort.reverse.map {|c| take(c)}
      cards.reverse!
      @table.place(@name,cards)
    end

    def score_hand
      self.cards_in_hand.each do |c|
        self.score += c.points
      end
    end

    def cards_on_table
      self.table.show("#{self.name}")
    end

    def win?
      cards_in_hand.empty?
    end
    
  end
end
