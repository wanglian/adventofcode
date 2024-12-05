file = File.open 'input.txt'
data = file.readline.chomp.split(',').map(&:to_i)
## for test
# data = [16,1,2,0,4,2,7,1,2,14]

data.sort!

re = 0
i = 0
while i < data.size/2
  re += data[data.size-1-i]
  re -= data[i]
  i += 1
end

p re
