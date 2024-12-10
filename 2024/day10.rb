require './utils.rb'

data = get_input("10").map do |row|
  row.split('').map(&:to_i)
end

def p1(data, uniq = false)
  # binding.break
  sum = 0
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      if v == 0
        sum += score(data, i, j, uniq)
      end
    end
  end
  sum
end

def score(data, x, y, uniq)
  i = 0
  paths = [[x, y]]
  while i < 9
    i += 1
    tmp = []
    paths.each do |path|
      x, y = path
      tmp << [x-1, y] if data[x-1][y] == i if x > 0
      tmp << [x, y-1] if data[x][y-1] == i if y > 0
      tmp << [x+1, y] if data[x+1][y] == i if x < (data.size - 1)
      tmp << [x, y+1] if data[x][y+1] == i if y < (data[0].size - 1)
    end
    paths = uniq ? tmp : tmp.uniq
  end
  paths.size
end

def p2(data)
  p1(data, true)
end

p p1(data)
p p2(data)
