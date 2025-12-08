require './utils.rb'

data = get_input("08").map { |row| row.split(',').map(&:to_i) }

def p1(data)
  distances = {}
  data.combination(2).each do |c|
    p1, p2 = c
    d =calc_distance(p1, p2)
    distances[d] = c
  end

  points = data.dup
  circuits = []
  distances.keys.sort.first(1000).each do |d|
    p1, p2 = distances[d]
    c1 = circuits.find { |c| c.include?(p1)}
    c2 = circuits.find { |c| c.include?(p2)}
    if c1
      if c1.include?(p2)
        next
      elsif c2
        circuits.delete_if { |c| c.include?(p2)}
        c1.concat(c2)
      else
        c1 << p2
      end
    elsif c2
      c2 << p1
    else
      circuits << [p1, p2]
    end
    points.delete p1
    points.delete p2
  end

  circuits.map(&:size).sort.last(3).inject(&:*)
end

def calc_distance(p1, p2)
  x1, y1, z1 = p1
  x2, y2, z2 = p2
  Math.sqrt((x1-x2)**2 + (y1-y2)**2 + (z1-z2)**2)
end

def p2(data)
  distances = {}
  data.combination(2).each do |c|
    p1, p2 = c
    d =calc_distance(p1, p2)
    distances[d] = c
  end

  points = data.dup
  circuits = []
  distances.keys.sort.each do |d|
    p1, p2 = distances[d].sort
    c1 = circuits.find { |c| c.include?(p1)}
    c2 = circuits.find { |c| c.include?(p2)}
    if c1
      if c1.include?(p2)
        next
      elsif c2
        circuits.delete_if { |c| c.include?(p2)}
        c1.concat(c2)
      else
        c1 << p2
      end
    elsif c2
      c2 << p1
    else
      circuits << [p1, p2]
    end
    points.delete p1
    points.delete p2

    if circuits.size == 1 && points.size == 0
      return p1[0] * p2[0]
    end
  end
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
