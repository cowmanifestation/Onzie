require "test/unit"
require "rubygems"
require "contest"
require "game"

class OnzieTest < Test::Unit::TestCase
  test "has players" do
    game = Onzie::Game.new("Ronald", "Judas", "Bob")

    assert_equal 3, game.players.size
  end

  test "has deck of cards" do
    game = Onzie::Game.new("Dorian")

    assert_kind_of Onzie::Deck, game.deck
  end

  test "each player can be dealt a hand of cards" do
    game = Onzie::Game.new("Vanderbilt", "Aria")
    game.deal

    assert_equal 7, game.players[0].cards_in_hand.size
    assert_equal 7, game.players[1].cards_in_hand.size
  end

  test "has discard pile" do
    game = Onzie::Game.new("JD")

    assert_kind_of Onzie::DiscardPile, game.discard_pile
  end

  test "when cards are dealt, a card is added to the discard pile" do
    game = Onzie::Game.new("Josiah")
    assert_equal 0, game.discard_pile.cards.size

    game.deal
    assert_equal 1, game.discard_pile.cards.size
  end

  test "player can draw from deck or discard pile" do
    game = Onzie::Game.new("Yvonne")
    game.deal

    game.draw(game.discard_pile)
    assert_equal 8, game.players[0].cards_in_hand.size
  end

  test "player discard is added to top of discard pile" do
    game = Onzie::Game.new("Harriet")
    game.deal
    
    game.discard([0])
    assert_equal 2, game.discard_pile.cards.size
  end

  def two_sets
    cards = []
    %w[c h s].map do |suit|
      cards << Onzie::Card.new(suit, "5")
    end
    %w[d h c].each do |suit|
      cards << Onzie::Card.new(suit, "8")
    end
    return cards
  end


  test "current player can lay completed collections down on table" do
    game = Onzie::Game.new("Rory", "Genevieve")
    game.players[0].cards_in_hand = two_sets

    cards = game.players[0].cards_in_hand.dup
    game.lay_down([0,1,2],[3,4,5])

    assert_equal cards, game.table.show("Rory").flatten
    assert_equal [], game.players[0].cards_in_hand
    
  end

  test "players are dealt appropriate amount of cards for each hand" do

    game = Onzie::Game.new("Damien", "Geraldine")

    [7,8,9,10,11,12,12].each_with_index do |hand, number|
      game.hand = number + 1

      game.deal
      cards = game.players[0].cards_in_hand

      assert_equal hand, cards.size

      game.players.each{|p| p.cards_in_hand.clear}
      game.deck = Onzie::Deck.new
    end
  end

  test "players collections are validated by game when laid down" do
    game = Onzie::Game.new("Axelrod")

    axelrod = game.players[0]

    axelrod.cards_in_hand = %w[2 3 4 5 6 7 8].map do |value|
      Onzie::Card.new("s", value)
    end

    assert_raises Onzie::Game::InvalidHandError do
      game.lay_down([0,1,2,3,4,5])
    end

    axelrod.cards_in_hand = two_sets


    cards = axelrod.cards_in_hand.dup
    game.lay_down([0,1,2],[3,4,5])

    assert_equal cards, axelrod.cards_on_table.flatten
  end

  test "current player switches when a player discards" do
    game = Onzie::Game.new("Brunhilde", "Quentin", "Constantina")
    game.deal
    assert_equal "Brunhilde", game.current_player.name

    game.discard
    assert_equal "Quentin", game.current_player.name

    game.discard
    assert_equal "Constantina", game.current_player.name

    game.discard
    assert_equal "Brunhilde", game.current_player.name
  end

  test "player wins when there are no more cards in hand" do
    game = Onzie::Game.new("Bryndlebob")
    bryndlebob = game.players[0]

    bryndlebob.cards_in_hand = two_sets

    bryndlebob.cards_in_hand << Onzie::Card.new("d", "9")

    game.lay_down([0,1,2], [3,4,5])
    game.discard
    assert bryndlebob.win?

    bryndlebob.cards_in_hand = %w[4 5 6 7].map do |value|
      Onzie::Card.new("h", value)
    end

    %w[c d h s].map do |suit|
      bryndlebob.cards_in_hand << Onzie::Card.new(suit, "3")
    end

    game.lay_down([0,1,2,3], [4,5,6,7])
    assert bryndlebob.win?
  end

  test "after a player wins the hand and number of cards dealt are increased" do
    game = Onzie::Game.new("Larry", "Rosenkrantz")
    game.deal
    assert_equal 7, game.players[0].cards_in_hand.size
    assert_equal 1, game.hand_number

    game.players[0].cards_in_hand = two_sets

    game.lay_down([3,4,5],[0,1,2])

    game.deal
    assert_equal 8, game.players[0].cards_in_hand.size

    assert_equal 2, game.hand_number
  end

  test "at beginning of each game and each hand deck is reset and shuffled" do
    game = Onzie::Game.new("Tristan", "Germaine")
    game.deal
    cards = game.current_player.cards_in_hand.dup

    game.current_player.cards_in_hand = two_sets
    game.lay_down([0,1,2],[3,4,5])

    assert_equal 52, game.deck.cards.size

    game.deal
    second_hand_cards = game.current_player.cards_in_hand.dup

    assert_not_equal cards[0..5], second_hand_cards[0..5]
  end

  test "when hand ends everyone's score increases according to number of cards in hand" do
  end

  test "first player switches with each hand" do
  end

  test "game adds deck when number of players & cards in hands is large" do
  end

  test "player with lowest score at end of seventh hand wins game" do
  end
end
