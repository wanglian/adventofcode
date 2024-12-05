file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '2199943210',
#   '3987894921',
#   '9856789892',
#   '8767896789',
#   '9899965678'
# ]

data = data.map {|row| row.split('').map(&:to_i)}

def check(data, i, j)
  data[i][j] = -1
  re = 1
  re += check(data, i-1, j) if i > 0 && ![-1, 9].include?(data[i-1][j])
  re += check(data, i, j-1) if j > 0 && ![-1, 9].include?(data[i][j-1])
  re += check(data, i+1, j) if i < (data.size-1) && ![-1, 9].include?(data[i+1][j])
  re += check(data, i, j+1) if j < (data[i].size-1) && ![-1, 9].include?(data[i][j+1])
  re
end

basins = []
data.each_with_index do |row, i|
  row.each_with_index do |n, j|
    next if n == 9 || n == -1
    basins << check(data, i, j)
  end
end
p basins.sort.last(3).inject(1) {|s, b| s*b}
