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

def build(data)
  rows = data.size
  columns = data[0].size
  5.times do |n|
    (0..(rows-1)).each do |i|
      (0..(columns-1)).each do |j|
        if n < 4
          v = (data[i][columns*n + j] + 1) % 10
          v = 1 if v == 0
          data[i][rows*(n+1) + j] = v
          data[rows*(n+1)+i] ||= []
          data[rows*(n+1)+i][j] = v
        end
        if n > 0
          4.times do |k|
            v = (data[rows*k+i][columns*n + j] + 1) % 10
            v = 1 if v == 0
            data[rows*(k+1)+i] ||= []
            data[rows*(k+1)+i][columns*n + j] = v
          end
        end
      end
    end
  end
end

def pp(dd)
  dd.each {|row| p row}
end

data = data.map{|row| row.split('').map(&:to_i)}
build data
# pp data

rows, columns = data.size, data[0].size
confirmed, temp = {'0-0' => 0}, {} # TODO: improve temp using minheap
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
