require './utils.rb'

data = get_input("06")

def p1(data)
  # binding.break
  data = data.map { |row| row.split(" ") }.transpose
  data.sum do |row|
    calc(row)
  end
end

def calc(row)
  return 0 if row.empty?
  operation = row.pop
  row = row.map(&:to_i)
  case operation
  when "*"
    row.inject(:*)
  when "+"
    row.inject(:+)
  else
    raise "not supported: #{operation}"
  end
end

def p2(data)
  size = data.size
  operations = data.pop.split(" ")
  data = data.map { |row| row.split("") }.transpose.map(&:join).map(&:strip)
  data = data.slice_when { |a, b| a == "" }.to_a
  data.each_with_index do |row, i|
    if row.last == ""
      row[row.size-1] = operations[i]
    else
      row << operations[i]
    end
  end
  data.sum { |row| calc(row) }
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
