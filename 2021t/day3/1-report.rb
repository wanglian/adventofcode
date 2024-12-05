file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

bits = []
data.each do |row|
  row.each_char.with_index do |c, i|
    bits[i] ||= 0
    bits[i] += 1 if c == '1'
  end
end

gamma = ""
epsilon = ""
size = data.size
bits.each do |b|
  if b > size/2
    gamma << '1'
    epsilon << '0'
  else
    gamma << '0'
    epsilon << '1'
  end
end

gamma = gamma.to_i 2
epsilon = epsilon.to_i 2

p "Number of binaries: #{data.count}"
p "Gamma: #{gamma}"
p "Epsilon: #{epsilon}"
p "Result: #{gamma * epsilon}"
