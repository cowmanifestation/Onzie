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

#  test "should be able to call methods on the player's name" do
#    # how does one implement such a thing???
  #    is it even a good idea?
#    game = Onzie::Game.new(["Esmerelda", "Rory", "Fiona"])
#    game.deal(7)
#
#    Esmerelda.draw(game.deck)
  #    one might rescue a NameError here - but you'd still have to be writing
  #    this method in the Game code and therefore you'd have to call it on a
  #    Game instance, somehow.
#    assert_equal 8, game.players["Esmerelda"].hand.size
#  end
  
  test "each player can be dealt a hand of cards" do
    game = Onzie::Game.new("Vanderbilt", "Aria")
    game.deal(7)

    assert_equal 7, game.players["Vanderbilt"].hand.size
    assert_equal 7, game.players["Aria"].hand.size
  end

  test "has discard pile" do
    game = Onzie::Game.new("JD")

    assert_kind_of Onzie::DiscardPile, game.discard_pile
  end

  test "when cards are dealt, a card is added to the discard pile" do
    game = Onzie::Game.new("Josiah")
    assert_equal 0, game.discard_pile.cards.size

    game.deal(7)
    assert_equal 1, game.discard_pile.cards.size
  end

  test "player can draw from deck or discard pile" do
    game = Onzie::Game.new("Yvonne")
    game.deal(7)

    game.players["Yvonne"].draw(game.discard_pile)
    assert_equal 8, game.players["Yvonne"].hand.size
  end

  test "player discard is added to top of discard pile" do
    game = Onzie::Game.new("Harriet")
    game.deal(7)
    
    harriet = game.players["Harriet"]

    harriet.discard([0], game.discard_pile)
    assert_equal 2, game.discard_pile.cards.size
  end

  test "player can lay completed collections down on table" do
    game = Onzie::Game.new("Rory", "Genevieve")
    game.deal(7)

    cards = game.players["Rory"].lay_down([0,1,2,3,4,5,6])

    assert_equal cards, game.table.show("Rory")
    assert_equal [], game.players["Rory"].hand
    
  end

  test "players are dealt appropriate amount of cards for each hand" do
  end

  test "players collections are validated by game when laid down" do
  end

  test "player wins when there are no more cards in hand" do
  end

  test "after a player wins the hand and number of cards dealt are increased" do
  end

  test "when hand ends everyone's score increases according to number of cards in hand" do
  end

  test "game adds another deck when number of players & cards in hands is large" do
  end
end
