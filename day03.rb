file = File.open 'day03.txt'
data = file.readlines.map(&:chomp)

mapping = {}
('a'..'z').each_with_index { |l, i| mapping[l] = i + 1 }
('A'..'Z').each_with_index { |l, i| mapping[l] = i + 27 }

data = data.map do |row|
  row.split('').map { |l| mapping[l] }
end

def p1(data)
  sum = 0
  data.each do |row|
    group = row.each_slice(row.size/2).to_a
    t = group[0] & group[1] # or .intersection
    t.any? && sum += t.uniq.sum
  end
  sum
end

def p2(data)
  sum = 0
  data.each_slice(3) do |group|
    t = group[0] & group[1] & group[2] # or .intersection
    t.any? && sum += t.uniq.sum
  end
  sum
end

p p1(data)
p p2(data)
