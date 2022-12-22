require './utils.rb'

data = get_input("18")

droplets = data.map { |r| r.split(',').map(&:to_i) }
# p droplets

def connected(d1, d2)
  dx = (d1[0] - d2[0]).abs
  dy = (d1[1] - d2[1]).abs
  dz = (d1[2] - d2[2]).abs
  [dx, dy, dz].sort == [0, 0, 1]
end

def p1(droplets)
  result = 0
  droplets.each.with_index do |d, i|
    result += 6
    if i > 0
      j = i - 1
      while j >= 0
        if connected(d, droplets[j])
          result -= 2
        end
        j -= 1
      end
    end
  end
  result
end

with_time { p p1(droplets) }
