require 'pry'
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

PS = [
  [3, 1],
  [4, 3],
  [5, 6],
  [6, 7],
  [7, 6],
  [8, 3],
  [9, 1]
]

def move(player, points)
  pos = player[:pos] + points
  pos= pos == 10? 10 : pos % 10
  {
    pos: pos,
    score: player[:score] + pos
  }
end

WIN_SCORE=21
@cache = {}
def win(p1, p2)
  cache = @cache["#{p1[:pos]}-#{p2[:pos]}-#{p1[:score]}-#{p2[:score]}"]
  return cache if cache
  re = [0, 0]
  PS.each do |pp1|
    p11 = move p1, pp1[0]
    if p11[:score] >= WIN_SCORE
      re[0] += pp1[1]
    else
      PS.each do |pp2|
        p22 = move p2, pp2[0]
        if p22[:score] >= WIN_SCORE
          re[1] += (pp1[1] * pp2[1])
        else
          r = win p11, p22
          re[0] += (pp1[1] * pp2[1] * r[0])
          re[1] += (pp1[1] * pp2[1] * r[1])
        end
      end
    end
  end
  @cache["#{p1[:pos]}-#{p2[:pos]}-#{p1[:score]}-#{p2[:score]}"] = re
  re
end

t1 = Time.new
p t1

p win(player1, player2)

t2 = Time.now
p t2
p (t2-t1)