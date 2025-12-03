require './utils.rb'

data = get_input("03").map do |row|
  row.split('').map(&:to_i)
end

def p1(data)
  # binding.break
  data.inject(0) do |sum, row|
    b1 = row.max
    i = row.index(b1) + 1
    if i == row.size
      b2 = row.pop
      b1 = row.max
    else
      b2 = row[i..].max
    end
    sum + "#{b1}#{b2}".to_i
  end
end

def p2(data)

end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
