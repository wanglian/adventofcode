require './utils.rb'

data = get_input("01")

def p1(data)
  # binding.break
  c = 50
  data.map do |d|
    [d[0], d[1..].to_i]
  end.inject(0) do |sum, move|
    direction, n = move
    if direction == 'R'
      c = (c + n) % 100
    else
      c = (c - n + 100) % 100
    end
    sum + (c == 0 ? 1 : 0)
  end
end

def p2(data)

end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
