file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map(&:to_i)

max = 0
sum = 0
data.each do |row|
  if row > 0
    sum += row
  else
    max = sum if sum > max
    sum = 0
  end
end
max = sum if sum > max

p max
