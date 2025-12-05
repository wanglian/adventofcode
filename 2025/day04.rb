require './utils.rb'

data = get_input("04").map { |row| row.split("") }

def p1(data)
  # binding.break
  count = 0
  data.each_with_index do |row, i|
    row.each_with_index do |c, j|
      next unless c == '@'
      count += 1 if papers(data, i, j) < 4
    end
  end
  count
end

def papers(data, i, j)
  mi, mj = data.size, data[0].size
  a = []
  a << [i-1, j] if i > 0
  a << [i+1, j] if i < (mi - 1)
  a << [i, j-1] if j > 0
  a << [i, j+1] if j < (mj - 1)
  a << [i-1, j-1] if i > 0 && j > 0
  a << [i-1, j+1] if i > 0 && j < (mj - 1)
  a << [i+1, j-1] if i < (mi - 1) && j > 0
  a << [i+1, j+1] if i < (mi - 1) && j < (mj - 1)
  a.sum do |pos|
    x, y = pos
    data[x][y] == "@" ? 1 : 0
  end
end

def move(data)
  count = 0
  data.each_with_index do |row, i|
    row.each_with_index do |c, j|
      next unless c == '@'
      if papers(data, i, j) < 4
        count += 1
        data[i][j] = '.'
      end
    end
  end
  count
end

def p2(data)
  result = 0
  while true
    count = move(data)
    break if count == 0
    result += count
  end
  result
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
