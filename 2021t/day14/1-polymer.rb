file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   'NNCB',
#   '',
#   'CH -> B',
#   'HH -> N',
#   'CB -> H',
#   'NH -> C',
#   'HB -> C',
#   'HC -> B',
#   'HN -> C',
#   'NN -> C',
#   'BH -> H',
#   'NC -> B',
#   'NB -> B',
#   'BN -> B',
#   'BB -> N',
#   'BC -> B',
#   'CC -> N',
#   'CN -> C',
# ]

template = data[0]
pairs = data[2..].map{|d| d.split(' -> ')}.to_h
# p template
# p pairs

def apply(template, pairs)
  i = 0
  while i < (template.size-1)
    s = pairs[template[i, 2]]
    if s
      i += 1
      template.insert i, s
    end
    i += 1
  end
end

10.times do
  apply template, pairs
end

counts = template.split('').tally.values.sort
p counts.last - counts.first
