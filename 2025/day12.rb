require './utils.rb'

shapes = []
regions = []

shape = []
get_input("12").each.with_index do |row, i|
  count = i / 5
  if count < 6
    next if i % 5 == 0
    if row.empty?
      shapes << shape
      shape = []
    else
      shape << row.split('')
    end
  else
    region, quantity = row.split(': ')
    width, length = region.split('x').map(&:to_i)
    regions << [width, length, quantity.split(' ').map(&:to_i)]
  end
end

def p1(shapes, regions)
  # not accurate, just compare area
  areas = shapes.map { |shape| shape.map(&:join).join.count('#') }
  regions.map do |width, length, quantity|
    sum = quantity.map.with_index { |q, i| q * areas[i] }.sum
    (width * length) > sum ? 1 : 0
  end.sum
end

def p2(shapes, regions)

end

p "Problem 1:"
with_time { p p1(shapes, regions) }
p "Problem 2:"
with_time { p p2(shapes, regions) }
