require './utils.rb'

data = get_input("14").map do |row|
  row.split(' ').map { |part| part.split('=')[1].split(',').map(&:to_i)}
end

def p1(data)
  # binding.break
  # area = [11, 7] # test
  area = [101, 103]
  ax, ay = area
  mx, my = area.map { |s| s/2 }
  c1, c2, c3, c4 = 0, 0, 0, 0
  data.each do |row|
    pos, vol = row
    px, py = pos
    vx, vy = vol
    px = px + vx * 100
    py = py + vy * 100
    px = cal(px, ax)
    py = cal(py, ay)

    if px < mx
      if py < my
        c1 += 1
      elsif py > my
        c3 += 1
      end
    elsif px > mx
      if py < my
        c2 += 1
      elsif py > my
        c4 += 1
      end
    end
  end
  c1 * c2 * c3 * c4
end

def cal(x, mod)
  if x >= 0
    x % mod
  else
    x %= (-mod)
    x < 0 ? x + mod : x
  end
end

def p2(data)
  i = 6180
  while true
    move(data, i)
    i += 1
    sleep 0.1
  end
end

def move(data, n)
  area = [101, 103]
  ax, ay = area
  map = Array.new(ay)
  data.each do |row|
    pos, vol = row
    px, py = pos
    vx, vy = vol
    px = px + vx * n
    py = py + vy * n
    px = cal(px, ax)
    py = cal(py, ay)
    map[py] ||= Array.new(ax, ' ')
    map[py][px] = 'X'
  end
  map.each do |row|
    row ||= Array.new(ax, ' ')
    p row.map { |v| v ? v : ' '}.join
  end
  p "===== #{n}"
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
