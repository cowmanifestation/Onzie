module Onzie
  module Rules
    InvalidSetError = Class.new(StandardError)
    InvalidRunError = Class.new(StandardError)
    InvalidHandError = Class.new(StandardError)

    def separate_twos(cards)
      twos = []
      indexes = []
      cards.each_with_index do |c, i|
        if c.value.to_i == 2
          twos << cards[i]
          indexes << i
        end
      end
      indexes.reverse.each do |i|
        cards.delete_at(i)
      end
      return twos
    end

    def validate_set(cards=[])
      twos = separate_twos(cards)
      if twos.length > 2
        raise InvalidSetError
      end
      
      value = cards[0].value
      cards.each do |c|
        unless c.value == value
          raise InvalidSetError
        end
      end
      twos.each {|t| cards << t}
      return cards
    end

    def validate_suit(cards)
      suit = cards[0].suit
      cards.each do |c|
        unless c.suit == suit
          raise InvalidRunError
        end
      end
    end

    def validate_consecutive(cards, twos)
      values = (cards[0].value.to_i..cards[-1].value.to_i).to_a

      values.each_with_index do |n, i|
        
        if n == cards[i].value.to_i
          # do nothing
        elsif two = twos.shift
          cards.insert(i, two)
          # insert two card at that position
        else
          raise InvalidRunError
        end
      end
    end

    def validate_run(cards=[])
      if cards.size < 4
        raise InvalidRunError
      end

      sorted_cards = cards.sort_by {|card| card.value.to_i }

      twos = separate_twos(sorted_cards)
      if twos.size > 2
        raise InvalidRunError
      end

      validate_suit(sorted_cards)
      validate_consecutive(sorted_cards, twos)

      return cards
    end

    def validate_big_run(cards=[])
      if cards.size < 7
        raise InvalidRunError
      end

      sorted_cards = cards.sort_by {|card| card.value.to_i }

      twos = separate_twos(sorted_cards)
      if twos.size > 3
        raise InvalidRunError
      end

      validate_suit(sorted_cards)
      validate_consecutive(sorted_cards, twos)

      return cards
    end

    def validate_elements_size(elements, num)
      unless elements.size == num
        raise InvalidHandError
      end
    end

    def validate_hand(num, *elements)
      case num
      when 1
        # seven cards
        validate_elements_size(elements, 2)
        elements.each do |e|
          validate_set(e)
        end
      when 2
        # eight cards
        validate_elements_size(elements, 2)

        validate_set(elements[0])
        validate_run(elements[1])
        return elements
      when 3
        # nine cards
        validate_elements_size(elements, 2)

        elements.each do |e|
          validate_run(e)
        end
      when 4
        # ten cards
        validate_elements_size(elements, 3)

        elements.each do |e|
          validate_set(e)
        end
      when 5
        # eleven cards
        validate_elements_size(elements, 2)

        validate_set(elements[0])
        validate_big_run(elements[1])
        return elements
      when 6
        # twelve cards
        validate_elements_size(elements, 3)

        validate_set(elements[0])
        [1, 2].each do |i|
          validate_run(elements[i])
        end
        return elements
      when 7
        # twelve cards
        validate_elements_size(elements, 3)

        [0, 1].each do |i|
          validate_set(elements[i])
        end
        validate_run(elements[2])
        return elements
      end
    end
  end
end
