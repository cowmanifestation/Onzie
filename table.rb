module Onzie
  class Table
    def initialize
      @cards_on_table = {}
    end
    attr_reader :cards_on_table

    def place(player, cards)
      @cards_on_table[player] = cards
    end

    def show(player)
      @cards_on_table[player]
    end
  end
end
