class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = Array.new(14) { Array.new }
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    four_stone_cup = [:stone, :stone, :stone, :stone]
    @cups.each_index do |i|
      @cups[i].concat(four_stone_cup) unless i == 6 || i == 13
    end
  end

  def valid_move?(start_pos)
    if start_pos <= 0 || start_pos > 13
      raise "Invalid starting cup"
    end
  end

  def make_move(start_pos, current_player_name)
    @cups[start_pos] = []
    i = start_pos
    until @cups[start_pos].empty?
      stones = @cups[start_pos]
      i += 1
      i = 0 if i > 13
      if i == 6
        @cups[6] << stones.shift if current_player_name == @name1
      elsif i == 13
        @cups[13] << stones.shift if current_player_name == @name2
      else
        @cups[i] << stones.shift
      end
    end

    render
    next_turn(i)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].count == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups.take(6).all? { |cup| cup.empty? } || @cups[7..12].all? { |cup| cup.empty? }
  end

  def winner
    player1_count = @cups[6].count
    player2_count = @cups[13].count

    if player1_count == player2_count
      :draw
    else
      player1_count > player2_count ? @name1 : @name2
    end
  end
end
