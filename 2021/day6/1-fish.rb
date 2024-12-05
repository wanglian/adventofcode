file = File.open 'input.txt'
data = file.readline.chomp.split(',').map(&:to_i)
## for test
# data = [3,4,3,1,2]

day = 1
while day <= 80
  i = 0
  size = data.size
  while i < size
    if data[i] == 0
      data[i] = 6
      data << 8
    else
      data[i] -= 1
    end
    i += 1
  end
  day += 1
end

p data.size
