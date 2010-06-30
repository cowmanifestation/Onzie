require "test/unit"
require "rubygems"
require "contest"
require "table"
require "player"
require "deck"

class TableTest < Test::Unit::TestCase
  test "should be able to view players' cards on table" do
    table = Onzie::Table.new

    player1 = Onzie::Player.new(table, "1")
    player2 = Onzie::Player.new(table, "2")
    player3 = Onzie::Player.new(table, "3")
    players = [player1, player2, player3]

    players.each_with_index do |p, i|
      p.hand = ["card#{i}"]
      p.lay_down([0])
    end

    assert_equal ["card0"], table.show(player1)
  end
end
