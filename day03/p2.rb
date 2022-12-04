file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

mapping = {}
('a'..'z').each_with_index { |l, i| mapping[l] = i + 1 }
('A'..'Z').each_with_index { |l, i| mapping[l] = i + 27 }

sum = 0
data.each_slice(3) do |group|
  c1 = group[0].split('').map { |l| mapping[l] }
  c2 = group[1].split('').map { |l| mapping[l] }
  c3 = group[2].split('').map { |l| mapping[l] }
  t = c1 & c2 & c3 # or .intersection
  unless t.empty?
    sum += t.uniq.sum
  end
end

p sum
