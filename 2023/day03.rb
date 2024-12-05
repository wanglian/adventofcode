require './utils.rb'

data = get_input("03")

def p1(data)
  m = data.length
  n = data[0].length
  data.each_with_index.inject(0) do |sum, (row, i)|
    parts = []
    j = 0
    part = ""
    while j < n
      if is_number(row[j])
        part += row[j]
      else
        unless part.empty?
          parts << part.to_i if is_part(i, j, part, data)
        end
        part = ""
      end
      j += 1
    end
    unless part.empty?
      parts << part.to_i if is_part(i, j, part, data)
    end
    sum + parts.sum
  end
end

def is_number(s)
  s.to_i.to_s == s
end

def is_symbol(s)
  s != '.' && !is_number(s)
end

def is_part(i, j, part, data)
  # top (i-1): j - part.size - 1 (>= 0) .. j
  if i > 0
    k = j - part.size
    k -= 1 if k > 0
    t = j
    t = j - 1 if j == data[0].size
    while k <= t
      return true if is_symbol(data[i-1][k])
      k += 1
    end
  end
  # i: j - part.size -1, j
  if j > part.size
    return true if is_symbol(data[i][j-part.size-1])
  end
  return true if j < data[0].size && is_symbol(data[i][j])
  # below (i+1): j - part.size - 1 (>= 0) .. j
  if i < (data.size-1)
    k = j - part.size
    k -= 1 if k > 0
    t = j
    t = j - 1 if j == data[0].size
    while k <= t
      return true if is_symbol(data[i+1][k])
      k += 1
    end
  end
  false
end

def p2(data)
  m = data.length
  n = data[0].length
  stars = {}
  data.each_with_index do |row, i|
    parts = []
    j = 0
    part = ""
    while j < n
      if is_number(row[j])
        part += row[j]
      else
        unless part.empty?
          if g = maybe_gear(i, j, part, data)
            stars["#{g[0]}-#{g[1]}"] ||= []
            stars["#{g[0]}-#{g[1]}"] << part.to_i
          end
        end
        part = ""
      end
      j += 1
    end
    unless part.empty?
      if g = maybe_gear(i, j, part, data)
        stars["#{g[0]}-#{g[1]}"] ||= []
        stars["#{g[0]}-#{g[1]}"] << part.to_i
      end
    end
  end
  stars.values.select do |gears|
    gears.size == 2
  end.inject(0) do |sum, gear|
    sum + gear[0] * gear[1]
  end
end

def is_star(s)
  s == '*'
end
def maybe_gear(i, j, part, data)
  # top (i-1): j - part.size - 1 (>= 0) .. j
  if i > 0
    k = j - part.size
    k -= 1 if k > 0
    t = j
    t = j - 1 if j == data[0].size
    while k <= t
      return [i-1, k] if is_star(data[i-1][k])
      k += 1
    end
  end
  # i: j - part.size -1, j
  if j > part.size
    return [i, j-part.size-1] if is_star(data[i][j-part.size-1])
  end
  return [i, j] if j < data[0].size && is_star(data[i][j])
  # below (i+1): j - part.size - 1 (>= 0) .. j
  if i < (data.size-1)
    k = j - part.size
    k -= 1 if k > 0
    t = j
    t = j - 1 if j == data[0].size
    while k <= t
      return [i+1, k] if is_star(data[i+1][k])
      k += 1
    end
  end
  false
end

p p1(data)
p p2(data)
