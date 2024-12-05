file = File.open 'input.txt'

data = [
  '..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#',
  '',
  '#..#.',
  '#....',
  '##..#',
  '..#..',
  '..###',
]

data = file.readlines.map(&:chomp)

algorithm = data[0]
input = data[2..].map{|row| row.split('')}

# p algorithm.size

# input.each {|row| p row.join}

def scale(input, bc)
  size = input.size
  input.each do |row|
    row.unshift bc
    row.push bc
  end
  input.unshift Array.new(size+2, bc)
  input.push Array.new(size+2, bc)
end

def convert(input, i, j, bc)
  l = input.size
  re = ''
  re += (i < 1 || i > l || j < 1 || j > l) ? bc : input[i-1][j-1]
  re += (i < 1 || i > l || j < 0 || j > (l-1)) ? bc : input[i-1][j]
  re += (i < 1 || i > l || j < -1 || j > (l-2)) ? bc : input[i-1][j+1]
  re += (i < 0 || i > (l-1) || j < 1 || j > l) ? bc : input[i][j-1]
  re += (i < 0 || i > (l-1) || j < 0 || j > (l-1)) ? bc : input[i][j]
  re += (i < 1 || i > (l-1) || j < -1 || j > (l-2)) ? bc : input[i][j+1]
  re += (i < -1 || i > (l-2) || j < 1 || j > l) ? bc : input[i+1][j-1]
  re += (i < -1 || i > (l-2) || j < 0 || j > (l-1)) ? bc : input[i+1][j]
  re += (i < -1 || i > (l-2) || j < -1 || j > (l-2)) ? bc : input[i+1][j+1]
  re.gsub('.', '0').gsub('#', '1').to_i 2
end

# p convert(input, 3, 3)
# p convert(input, 2, 2)

def enhance(input, algorithm, bc='.')
  scale input, bc
  # input.each {|row| p row.join}
  re = []
  input.each_with_index do |row, i|
    re[i] = []
    row.each_with_index do |d, j|
      c = convert input, i, j, bc
      re[i][j] = algorithm[c]
    end
  end
  re
end

output = input
50.times do |i|
  if i % 2 == 0
    output = enhance output, algorithm
  else
    output = enhance output, algorithm, algorithm[0]
  end
end
p output.map(&:join).join.count('#')
