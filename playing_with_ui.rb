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
