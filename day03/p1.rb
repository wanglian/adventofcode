file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

mapping = {}
('a'..'z').each_with_index { |l, i| mapping[l] = i + 1 }
('A'..'Z').each_with_index { |l, i| mapping[l] = i + 27 }

sum = 0
data.each do |row|
  c1 = row[0, row.size/2].split('').map { |l| mapping[l] }
  c2 = row[row.size/2, row.size/2].split('').map { |l| mapping[l] }
  t = c1 & c2 # or .intersection
  unless t.empty?
    sum += t.uniq.sum
  end
end

p sum
