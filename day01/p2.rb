file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map(&:to_i)

max = [0, 0, 0]
sum = 0
data.each do |row|
  if row > 0
    sum += row
  else
    if sum > max.first
      max[0] = sum
      max.sort!
    end
    sum = 0
  end
end
max[0] = sum if sum > max.first

p max
p max.sum
