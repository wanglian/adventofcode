file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map(&:to_i)

count = 0
pos = 1
while pos < (data.size - 2)
  sum1 = data[pos - 1] + data[pos] + data[pos + 1]
  sum2 = data[pos] + data[pos + 1] + data[pos + 2]
  count += 1 if sum2 > sum1
  pos += 1
end
p "Number of measurements: #{data.size}"
p "Number of window increases: #{count}"
