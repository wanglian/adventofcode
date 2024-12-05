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

re = []
data.each_with_index do |row, j|
  row.each_with_index do |n, i|
    next if i > 0 && row[i-1] <= n
    next if i < (row.size-1) && row[i+1] <= n
    next if j > 0 && data[j-1][i] <= n
    next if j < (data.size-1) && data[j+1][i] <= n
    re << n
  end
end

point = re.sum + re.size
p point
