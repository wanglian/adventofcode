file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '5483143223',
#   '2745854711',
#   '5264556173',
#   '6141336146',
#   '6357385478',
#   '4167524645',
#   '2176841721',
#   '6882881134',
#   '4846848554',
#   '5283751526',
# ]

data = data.map {|row| row.split('').map(&:to_i)}
total = data.size * data[0].size

def pd(data, i)
  p "after step #{i}"
  data.each do |row|
    p row
  end
end

def flash(data, i, j)
  data[i-1][j-1] += 1 if i > 0 && j > 0
  data[i-1][j] += 1 if i > 0
  data[i-1][j+1] += 1 if i > 0 && j < (data[i].size-1)
  data[i][j-1] += 1 if j > 0
  data[i][j+1] += 1 if j < (data[i].size-1)
  data[i+1][j-1] += 1 if i < (data.size-1) && j > 0
  data[i+1][j] += 1 if i < (data.size-1)
  data[i+1][j+1] += 1 if i < (data.size-1) && j < (data[i].size-1)
  data[i][j] = 1000
end

def restep(data)
  # pd data, '='
  count = 0
  data.each_with_index do |row, i|
    row.each_with_index do |n, j|
      if n > 9 && n < 1000
        flash(data, i, j)
        count += 1
      end
    end
  end
  restep(data) if count > 0
  count
end

def step(data)
  data.each_with_index do |row, i|
    row.each_with_index do |n, j|
      if n >= 9
        flash(data, i, j)
      else
        data[i][j] += 1
      end
    end
  end
  restep data
  count = 0
  data.each_with_index do |row, i|
    row.each_with_index do |n, j|
      if n > 9
        data[i][j] = 0
        count += 1
      end
    end
  end
  count
end

i = 1
while true
  if total == step(data)
    break
  end
  i += 1
end

p i
