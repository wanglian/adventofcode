require './utils.rb'

data = get_input("13")

patterns = []
pattern = []
data.each do |row|
  # binding.break
  if row.empty?
    patterns << pattern
    pattern = []
  else
    pattern << row.split('')
  end
end
patterns << pattern

def p1(patterns)
  result = 0
  patterns.each do |pattern|
    v = vertical(pattern)
    if v > 0
      result += v
      next
    end
    h = horizontal(pattern)
    if h > 0
      result += h * 100
    end
  end
  result
end

def vertical(pattern, exclude=0)
  y = 0
  while y < (pattern[0].size - 1)
    if vertical_equal(pattern, y, y+1)
      l = y-1
      r = y+2
      reflection = true
      while l >= 0 && r < pattern[0].size
        unless vertical_equal(pattern, l, r)
          reflection = false
          break
        end
        l -= 1
        r += 1
      end
      return y+1 if reflection && (y+1) != exclude
    end
    y += 1
  end
  0
end

def vertical_equal(pattern, i, j)
  x = 0
  while x < pattern.size
    return false unless pattern[x][i] == pattern[x][j]
    x += 1
  end
  true
end

def horizontal(pattern, exclude=0)
  x = 0
  while x < (pattern.size - 1)
    if horizontal_equal(pattern, x, x+1)
      u = x - 1
      d = x + 2
      reflection = true
      while u >= 0 && d < pattern.size
        unless horizontal_equal(pattern, u, d)
          reflection = false
          break
        end
        u -= 1
        d += 1
      end
      return x+1 if reflection && (x+1) != exclude
    end
    x += 1
  end
  0
end

def horizontal_equal(pattern, i, j)
  y = 0
  while y < pattern[0].size
    return false unless pattern[i][y] == pattern[j][y]
    y += 1
  end
  true
end

def p2(patterns)
  result = 0
  patterns.each do |pattern|
    result += fix(pattern)
  end
  result
end

def fix(pattern)
  pattern.each_with_index do |row, x|
    row.each_with_index do |vv, y|
      v0 = vertical(pattern)
      h0 = horizontal(pattern)
      pattern[x][y] = opposite(vv)
      v = vertical(pattern, v0)
      if v > 0
        return v
      end
      h = horizontal(pattern, h0)
      if h > 0
        return h * 100
      end
      pattern[x][y] = vv
    end
  end
  raise "no fix!"
end

def opposite(v)
  v == '.' ? '#' : '.'
end

p p1(patterns)
p p2(patterns)
