require './utils.rb'

data = get_input("01").map do |d|
  [d[0], d[1..].to_i]
end

def p1(data)
  # binding.break
  c = 50
  data.inject(0) do |sum, move|
    direction, n = move
    if direction == 'R'
      c += n
    else
      c -= n
    end
    c %= 100
    sum + (c == 0 ? 1 : 0)
  end
end

def p2(data)
  c = 50
  data.inject(0) do |sum, move|
    direction, n = move
    z = 0
    if direction == 'R'
      c += n
      z = c / 100
      c %= 100
    else
      if c == 0
        c += 100
      end
      c -= n
      z = - (c / 100)
      c %= 100
      z += 1 if c == 0
    end
    sum + z
  end
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
