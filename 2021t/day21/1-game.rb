file = File.open 'input.txt'

data = [
  'Player 1 starting position: 4',
  'Player 2 starting position: 8',
]

data = file.readlines.map(&:chomp)

data = data.map {|row| row[-1]}.map &:to_i

p data

player1 = {
  score: 0,
  pos: data[0]
}

player2 = {
  score: 0,
  pos: data[1]
}

dice = {
  value: 0,
  count: 0
}

def roll(dice)
  dice[:value] = dice[:value] == 100 ? 1 : dice[:value] + 1
  dice[:count] += 1
  dice
end

def calc_pos(pos, points)
  re = (pos + points) % 10
  re == 0 ? 10 : re
end

def move(player, dice)
  points = 0
  3.times do
    dice = roll dice
    points += dice[:value]
  end
  # p points, dice
  player[:pos] = calc_pos player[:pos], points
  player[:score] += player[:pos]
  # p player
end

loser = nil
while true
  move player1, dice
  if player1[:score] >= 1000
    loser = player2
    break
  end
  move player2, dice
  if player2[:score] >= 1000
    loser = player1
    break
  end
end

p player1, player2
p loser[:score] * dice[:count]
