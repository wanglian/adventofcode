file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '6,10',
#   '0,14',
#   '9,10',
#   '0,3',
#   '10,4',
#   '4,11',
#   '6,0',
#   '6,12',
#   '4,1',
#   '0,13',
#   '10,12',
#   '3,4',
#   '3,0',
#   '8,4',
#   '1,10',
#   '2,14',
#   '8,10',
#   '9,0',
#   '',
#   'fold along y=7',
#   'fold along x=5',
# ]

points = []
i = 0
while true
  break if data[i].empty?
  points << data[i].split(',').map(&:to_i)
  i += 1
end
folds = []
i += 1
while i < data.size
  folds << data[i].gsub('fold along ', '').split('=')
  i += 1
end

# p "Points: #{points.size}"
# p folds

def fold(points, f)
  k = f[1].to_i
  case f[0]
  when 'x'
    points.each do |point|
      if point[0] > k
        point[0] -= (point[0] - k) * 2
      end
    end
  when 'y'
    points.each do |point|
      if point[1] > k
        point[1] -= (point[1] - k) * 2
      end
    end
  end
end

def pp(points)
  board = []
  points.each do |p|
    board[p[1]] ||= []
    board[p[1]][p[0]] = '#'
  end
  board.each do |row|
    row ||= Array.new 1
    p row.map{|d| d ||= '.'}.join
  end
end

folds.each do |f|
  fold points, f
  points.uniq!
end

pp points
