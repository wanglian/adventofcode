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

def check_trapped(droplets)
  result = []
 
  xs = droplets.map { |d| d[0] }.uniq.sort # x
  return [] if xs.size < 3
  xs.each.with_index do |x, i|
    next if i == 0 || i == xs.length - 1
    x_droplets = droplets.select { |d| d[0] == x }
    ys = x_droplets.map { |d| d[1] }.uniq.sort # y
    break if ys.size < 3
    ys.each.with_index do |y, j|
      next if j == 0 || j == ys.length - 1
      y_droplets = x_droplets.select { |d| d[1] == y }
      zs = y_droplets.map { |d| d[2] }.uniq.sort # z
      break if zs.size < 3
      z = zs[1]
      # binding.irb
      while z < zs.last
        unless zs.include?(z)
          tys = x_droplets.select { |d| d[2] == z }.map { |d| d[1] }.uniq.sort
          next if tys.size < 3
          if y > tys.first && y < tys.last
            txs = droplets.select { |d| d[1] == y && d[2] == z }.map { |d| d[0] }.uniq.sort
            next if txs.size < 3
            if x > txs.first && x < txs.last
              result << [x, y, z]
            end
          end
        end
        z += 1
      end
    end
  end
  result
end

def p2(droplets)
  result = p1(droplets)
  p result
  trapped = check_trapped(droplets)
  p trapped
  nt = p1(trapped)
  p "trapped: #{nt}"
  result -= nt
  dup_trapped = check_trapped(trapped)
  p dup_trapped
  result += p2(dup_trapped) unless dup_trapped.empty?
  p "result: #{result}"
  result
end

# part 1
# with_time { p p1(droplets) }
# part 2
with_time { p p2(droplets) }
