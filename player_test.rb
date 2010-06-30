require "test/unit"
require "rubygems"
require "contest"
require "deck"
require "player"
require "table"

class PlayerTest < Test::Unit::TestCase

  test "players have names" do
    table = "fake table"
    thor = Onzie::Player.new(table, "Thor")

    assert_equal "Thor", thor.name
  end


  test "player has hand of cards" do
    table = "fake table because it doesn't matter here"
    percival = Onzie::Player.new(table, "Percival")
    percival.hand << Onzie::Card.new("H", "K") << Onzie::Card.new("D", "5")

    assert_equal 2, percival.hand.size
  end

  test "player has score" do
    table = "fake table because it doesn't matter here"
    anderson = Onzie::Player.new(table, "Anderson")
    
    assert_equal 0, anderson.score
  end

  test "player should be able to draw a card" do
    table = "fake table because it doesn't matter here"
    renee = Onzie::Player.new(table, "Renee")
    deck = Onzie::Deck.new
    initial_hand_size = renee.hand.size
    renee.draw(deck)
    
    assert_equal 0, initial_hand_size
    assert_equal 1, renee.hand.size
  end

  test "player should be able to discard into discard pile" do
    deck = Onzie::Deck.new
    discard_pile = Onzie::DiscardPile.new
    table = Onzie::Table.new
    dolores = Onzie::Player.new(table, "Dolores")

    discard_pile_initial_size = discard_pile.cards.size
    discard_pile_size_after_one_discard = discard_pile_initial_size + 1

    dolores.hand = deck.draw(7)
    assert_equal 7, dolores.hand.size

    dolores.discard([0], discard_pile)
    assert_equal 6, dolores.hand.size
    assert_equal discard_pile_size_after_one_discard, discard_pile.cards.size
    #write a test here to validate the card by asking for its value
  end

  test "should be able to lay cards down on table" do
    discard_pile = Onzie::DiscardPile.new
    deck = Onzie::Deck.new
    table = Onzie::Table.new
    samson = Onzie::Player.new(table, "Samson")
    samson.hand = deck.draw(7)

    assert_nil table.show(samson)

    samson.lay_down([0,1,2,3,4,5])

    assert_equal 6, table.cards_on_table[samson].size
    assert_equal 1, samson.hand.size
  end

  test "cards in hand should be able to be added to score" do
    table = "fake table because it doesn't matter here"
    zelda = Onzie::Player.new(table, "Zelda")
    deck = Onzie::Deck.new
    zelda.hand = deck.draw(7)

    zelda.score_hand
    assert_equal 50, zelda.score
  end
end
