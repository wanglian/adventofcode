file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map(&:to_i)

count = 0
pos = 1
while pos < data.size
  count += 1 if data[pos] > data[pos - 1]
  pos += 1
end
p "Number of measurements: #{data.size}"
p "Number of increases: #{count}"
