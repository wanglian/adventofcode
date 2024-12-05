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

template = data[0].split('')
@pairs = data[2..].map{|d| d.split(' -> ')}.to_h

@cache = {}
def poly(p1, p2, n)
  count = @cache["#{p1}-#{p2}-#{n}"]
  return count if count

  s = @pairs[[p1, p2].join]
  count =
    if n == 0 || s.nil?
      {p1 => 1}
    else
      c1 = poly p1, s, n-1
      c2 = poly s, p2, n-1
      c1.merge(c2) {|k, ov, nv| ov + nv}
    end
  
  @cache["#{p1}-#{p2}-#{n}"] = count
  count
end

STEPS = 40
counts = {}
(0..(template.length-2)).each do |i|
  counts.merge!(poly(template[i], template[i+1], STEPS)) {|k, ov, nv| ov + nv}
end
counts[template.last] += 1

count = counts.values.sort
p count.last - count.first
