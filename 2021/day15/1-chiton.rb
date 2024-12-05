file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '1163751742',
#   '1381373672',
#   '2136511328',
#   '3694931569',
#   '7463417111',
#   '1319128137',
#   '1359912421',
#   '3125421639',
#   '1293138521',
#   '2311944581',
# ]

data = data.map{|row| row.split('').map(&:to_i)}

rows, columns = data.size, data[0].size
confirmed, temp = {'0-0' => 0}, {}
i, j = 0, 0
#  Dijkstra
while i < (rows-1) || j < (columns-1)
  base = confirmed["#{i}-#{j}"]
  [[i-1, j], [i, j-1], [i+1, j], [i, j+1]].each do |pos|
    k = "#{pos[0]}-#{pos[1]}"
    if (0..(rows-1)).include?(pos[0]) && (0..(columns-1)).include?(pos[1]) && !confirmed[k]
      v = base + data[pos[0]][pos[1]]
      temp[k] = v if !temp[k] || temp[k] > v
    end
  end

  min = temp.min {|a, b| a[1] <=> b[1]}
  confirmed[min[0]] = min[1]
  temp.delete min[0]

  p = min[0].split('-').map &:to_i
  i, j = p[0], p[1]
end

def pp(hh)
  dd = []
  hh.each do |k, v|
    p = k.split('-').map &:to_i
    dd[p[0]] ||= []
    dd[p[0]][p[1]] = v
  end
  dd.each {|row| p row}
end

# pp confirmed
p confirmed["#{i}-#{j}"]
