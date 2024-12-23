require './utils.rb'

data = get_input("22").map(&:to_i)

def pridict(n)
  n = ((n * 64) ^ n) % 16777216
  n = ((n / 32) ^ n) % 16777216
  ((n * 2048) ^ n) % 16777216
end

def p1(data)
  data.inject(0) do |sum, d|
    2000.times { d = pridict(d)}
    sum + d
  end
end

def sequences(d)
  result = {}
  sequence = []
  2000.times do |i|
    nd = pridict(d)
    rnd = nd % 10
    diff = rnd - d % 10
    sequence.push diff
    sequence.shift if sequence.size > 4
    result[sequence.dup] = rnd if sequence.size == 4 && !result[sequence]
    d = nd
  end
  result
end

def p2(data)
  data.inject({}) do |sum, d|
    sum.merge(sequences(d)) { |k, v1, v2| v1 + v2 }
  end.values.max
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
