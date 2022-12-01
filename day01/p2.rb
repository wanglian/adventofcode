file = File.open 'input.txt'
data = file.readlines.map(&:chomp).map(&:to_i)

max = []
sum = 0
data.each do |row|
  if row > 0
    sum += row
  else
    if max.length < 3
      max << sum
    elsif sum > max.first
      max[0] = sum
    end
    max.sort!
    sum = 0
  end
end

if max.length < 3
  max << sum
elsif sum > max.first
  max[0] = sum
end

p max
p max.sum
