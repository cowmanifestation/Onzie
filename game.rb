require "player"
require "deck"
require "table"
require "rules"
require "forwardable"

module Onzie
  class Game
    include Rules
    extend Forwardable
    def initialize(*player_names)
      @table = Table.new
      @players = player_names.map do |p|
        Player.new(@table, p)
      end
      
      create_new_deck
      @discard_pile = DiscardPile.new
      @hand_number = 1
      @current_player = @players.first
    end

    attr_accessor :players, :current_player, :deck, 
                  :discard_pile, :table, :hand_number

    def_delegators :@current_player, :draw, :win

    def create_new_deck
      @deck = Deck.new
    end

    def hand_ended?
      @current_player.cards_in_hand.empty?
    end

    def start_new_hand
      @hand_number += 1
      create_new_deck
    end

    def discard(card_index=[0])
      @current_player.discard(@discard_pile, card_index)
      if hand_ended?
        @current_player.win?
        start_new_hand
      else
        switch_players
      end
    end

    def lay_down(*collections)
      cards = collections.map do |c|
        c.map do |i|
          current_player.cards_in_hand[i]
        end
      end

      if cards.size == 2
        validate_hand(self.hand_number, cards[0], cards[1])
        @current_player.lay_down(collections[0], collections[1])
      else
        validate_hand(self.hand_number, cards[0], cards[1], cards[2])
        @current_player.lay_down(collections[0], collections[1], 
                                 collections[2])
      end

      if hand_ended?
        start_new_hand
      end
    end

    def deal
      @deck.shuffle
      number = number_in_hand[@hand_number]
      @players.each do |p|
        p.cards_in_hand = @deck.draw(number)
      end
      @discard_pile.cards << @deck.draw
    end

    def hand=(number)
      @hand_number = number
    end

    def number_in_hand
      {1 => 7, 2 => 8, 3 => 9, 4 => 10, 5 => 11, 6 => 12, 7 => 12}
    end

    def switch_players
      @players.push(@players.shift) 
      @current_player = @players.first
    end
  end
end
