file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

depth = 0
h_pos = 0

data.each do |row|
  action, unit = row.split(' ')
  unit = unit.to_i
  case action
  when 'forward'
    h_pos += unit
  when 'down'
    depth += unit
  when 'up'
    depth -= unit
  end
end

p "Number of operations: #{data.count}"
p "Depth: #{depth}"
p "Horizontal position: #{h_pos}"
p "Result: #{h_pos * depth}"
