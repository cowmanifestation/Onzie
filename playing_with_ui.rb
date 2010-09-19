# QUESTIONS
#
# Is there a way to be able to call methods on a player's name during a game
# instance?  ...Or is that something to be arranged only in the UI (perhaps in
# Hiline)?
#
# Create a new instance of Game and go through hands in the game; hand number
# increasing when a player wins by getting rid of its cards?
#
# class Game
#   initialize(*players)
# ...
#
# Players playing on others' hands:
# player.lay_down(card, player=self)
#   if player.cards_on_table
#     add_to(cards_on_table, player)
#     validate_hand(player.cards_on_table)
#   else
#     validate_hand(cards)
#     player.cards_on_table = cards
#   end
#
# The table for the game should have players instead of the players each
# having a table. ...but then the lay_down method would have to take a table as
# an argument??? Or..the lay_down function could just return the cards.  See
# below:
# def lay_down(card_indexes=[], table, player_name=self.name)
#
# See the note above: laying down cards should include the capability of laying
# cards down on others' hands as well.
#
#
# Players turns should be created by the game - when you call lay_down on the
# game it automatically calls it on the current player.
#
# For the above to be possible:
#
# need current_player method
#
# game needs draw_card method which gives current_player a card from deck
#
# game needs discard method, which puts card in discard pile, and switches
# current_player
#
# game needs lay_down method, takes cards from current_player's hand, validates
# the collection, and either raises an error or lays them down on the table
#
# lay_down (or play_on()) method needs to be able to add cards to other player's
# cards on table as well as current_player's.
#
# if player discards or lays down a card and their hand becomes empty, they
# win.
#
# score is then taken and recorded; hand number and number of cards to be dealt
# is increased, or if it's the last hand, the player with the highest score
# wins.








game
  # game.new? Or module onzie; extend self; end ?
  Onzie::Game.new(players=["player", "names"])
    players.each {|p| Onzie::Player.new(table, p )}
      hand
    @table = Onzie::Table.new
    @deck
      cards
    @discard_pile
    @hand = 1

  # players = %w[colista ringo chenoa]
  colista = Onzie::Player.new

start_hand
  (hand_number = 1)
colista.play_turn
  colista.draw_card
  colista.discard(card_from_hand)
   => colista.end_turn
ringo.play_turn
  ringo.draw_card
  ringo.discard(card_from_hand)
   => ringo.end_turn
....

colista.lay_down(set_1, set_2)
  => validate_hand(1, set_1, set_2)
colista.discard(card_from_hand)
..

ringo.lay_down(set_1, set_2)
...
chenoa.lay_down(set_1, set_2)
...

ringo.play(colista, set_1, index, card)
ringo.discard
  => "Ringo Wins!"
  => end_of_hand
  (hand_number += 1)
