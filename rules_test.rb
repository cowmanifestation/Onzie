require "rubygems"
require "test/unit"
require "contest"
require "rules"
require "deck"

class RulesTest < Test::Unit::TestCase
  module Onzie::Rules
    extend self
  end

  def create_set(value)
    ["c", "s", "h"].map do |s|
      Onzie::Card.new(s, value)
    end
  end

  def create_run(suit, number_of_cards=4)
    (3..number_of_cards + 2).map do |v|
      Onzie::Card.new(suit, v.to_s)
    end
  end

  test "set must have at least three cards with the same value" do
    card_1 = Onzie::Card.new("c", "8")
    card_2 = Onzie::Card.new("h", "8")
    card_3 = Onzie::Card.new("s", "8")
    assert_equal Onzie::Rules.validate_set([card_1, card_2, card_3]), 
                 [card_1, card_2, card_3]

    card_4 = Onzie::Card.new("c", "9")

    assert_raises Onzie::Rules::InvalidSetError do
      Onzie::Rules.validate_set([card_1, card_2, card_4])
    end
  end

  test "sets must also work with twos" do
    card_1 = Onzie::Card.new("c", "8")
    card_2 = Onzie::Card.new("h", "8")
    card_3 = Onzie::Card.new("s", "2")

    assert_equal Onzie::Rules.validate_set([card_1, card_2, card_3]), 
                 [card_1, card_2, card_3]
  end

  test "set must not have more than two twos" do
    card_1 = Onzie::Card.new("c", "8")
    card_2 = Onzie::Card.new("c", "2")
    card_3 = Onzie::Card.new("h", "2")

    assert_equal Onzie::Rules.validate_set([card_1, card_2, card_3]),
                 [card_1, card_2, card_3]

    card_4 = Onzie::Card.new("s", "2")


    assert_raises Onzie::Rules::InvalidSetError do
      Onzie::Rules.validate_set([card_2, card_3, card_4])
    end

    assert_raises Onzie::Rules::InvalidSetError do
      Onzie::Rules.validate_set([card_1, card_2, card_3, card_4])
    end
  end

  test "runs must contain at least four cards in the same suit with consecutive values" do
    card_1 = Onzie::Card.new("c", "7")
    card_2 = Onzie::Card.new("c", "8")
    card_3 = Onzie::Card.new("c", "9")

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_run([card_1, card_2, card_3])
    end

    card_4 = Onzie::Card.new("c", "10")
    assert_equal Onzie::Rules.validate_run([card_1, card_2, card_3, card_4]), 
                 [card_1, card_2, card_3, card_4]

    card_5 = Onzie::Card.new("s", "10")
    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_run([card_1, card_2, card_3, card_5])
    end
  end

  test "runs must work with twos inserted at any point" do
    card_1 = Onzie::Card.new("c", "7")
    card_2 = Onzie::Card.new("c", "8")
    card_3 = Onzie::Card.new("c", "9")
    card_4 = Onzie::Card.new("h", "2")

    assert_equal Onzie::Rules.validate_run([card_1, card_2, card_3, card_4]),
                 [card_1, card_2, card_3, card_4]

    card_5 = Onzie::Card.new("c", "10")

    assert_equal Onzie::Rules.validate_run([card_1, card_2, card_4, card_5]),
                 [card_1, card_2, card_4, card_5]

    card_6 = Onzie::Card.new("c", "4")
    card_7 = Onzie::Card.new("c", "5")
    
    assert_equal Onzie::Rules.validate_run([card_7, card_4, card_1, card_2]),
                 [card_7, card_4, card_1, card_2]

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_run([card_6, card_1, card_2, card_4])
    end

    card_8 = Onzie::Card.new("c", "11")

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_run([card_1, card_2, card_4, card_8])
    end
  end

  test "runs must not have more than two twos" do
    card_1 = Onzie::Card.new("c", "7")
    card_2 = Onzie::Card.new("c", "8")
    card_3 = Onzie::Card.new("c", "2")
    card_4 = Onzie::Card.new("h", "2")

    assert_equal Onzie::Rules.validate_run([card_1, card_2, card_3, card_4]),
                 [card_1, card_2, card_3, card_4]

    card_5 = Onzie::Card.new("s", "2")

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_run([card_1, card_3, card_4, card_5])
    end

  end

  test "hands must have proper amount of sets or runs" do
  end

  test "first hand must have two sets" do
    set_1 = create_set("7")

    assert_raises Onzie::Rules::InvalidHandError do
      Onzie::Rules.validate_hand(1, set_1)
    end

    set_2 = create_set("8")

    assert_equal Onzie::Rules.validate_hand(1, set_1, set_2),
                 [set_1, set_2]

    set_2 << Onzie::Card.new("h", "9")

    assert_raises Onzie::Rules::InvalidSetError do
      Onzie::Rules.validate_hand(1, set_1, set_2)
    end
  end

  test "second hand must have a set and a run" do
    set = create_set("7")
    run = create_run("h")

    assert_equal Onzie::Rules.validate_hand(2, set, run),
                 [set, run]
    assert_equal Onzie::Rules.validate_hand(2, run, set),
                 [run, set]

    set_2 = create_set("5")

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_hand(2, set, set_2)
    end
  end

  test "third hand must have two runs" do
    run_1 = create_run("h")
    run_2 = create_run("c")

    assert_equal Onzie::Rules.validate_hand(3, run_1, run_2),
                 [run_1, run_2]
  end

  test "fourth hand must have three sets" do
    set_1 = create_set("7")
    set_2 = create_set("8")
    set_3 = create_set("9")

    assert_equal Onzie::Rules.validate_hand(4, set_1, set_2, set_3),
                 [set_1, set_2, set_3]
  end

  test "fifth hand must have a set and a run of seven" do
    set = create_set("7")
    run = create_run("h", 7)

    assert_equal Onzie::Rules.validate_hand(5, set, run),
                 [set, run]
    assert_equal Onzie::Rules.validate_hand(5, run, set),
                 [run, set]

    bad_run = %w[ 3 4 5 6 8 9 10 ].map do |v|
      Onzie::Card.new("h", v)
    end

    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_hand(5, set, bad_run)
    end
    assert_raises Onzie::Rules::InvalidRunError do
      Onzie::Rules.validate_hand(5, bad_run, set)
    end
  end

  test "sixth hand must have two runs and a set" do
    set = create_set("7")
    run_1 = create_run("h")
    run_2 = create_run("s")

    assert_equal Onzie::Rules.validate_hand(6, set, run_1, run_2),
                 [set, run_1, run_2]
    assert_equal Onzie::Rules.validate_hand(6, run_1, run_2, set),
                 [run_1, run_2, set]
    assert_equal Onzie::Rules.validate_hand(6, run_1, set, run_2),
                 [run_1, set, run_2]
  end

  test "seventh hand must have two sets and a run" do
    set_1 = create_set("7")
    set_2 = create_set("8")
    run = create_run("h")

    assert_equal Onzie::Rules.validate_hand(7, set_1, set_2, run),
                 [set_1, set_2, run]
    assert_equal Onzie::Rules.validate_hand(7, run, set_1, set_2),
                 [run, set_1, set_2]
    assert_equal Onzie::Rules.validate_hand(7, set_1, run, set_2),
                 [set_1, run, set_2]
  end
end
