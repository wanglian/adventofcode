data = File.open('input/day08.txt').readlines.map(&:chomp)
  .map { |row| row.split('').map(&:to_i) }

def p1(data)
  result = {}
  # up
  i = 1
  com_arr = []
  while i < (data.length - 1)
    j = 1
    while j < (data[i].length - 1)
      com_arr[j] ||= data[0][j]
      if data[i][j] > com_arr[j]
        result["#{i}-#{j}"] = true
        com_arr[j] = data[i][j]
      end
      j += 1
    end
    i += 1
  end
  # down
  i = data.length - 2
  com_arr = []
  while i > 0
    j = data[0].length - 2
    while j > 0
      com_arr[j] ||= data.last[j]
      if data[i][j] > com_arr[j]
        result["#{i}-#{j}"] = true
        com_arr[j] = data[i][j]
      end
      j -= 1
    end
    i -= 1
  end
  # left
  j = 1
  com_arr = []
  while j < (data[0].length - 1)
    i = 1
    while i < (data.length - 1)
      com_arr[i] ||= data[i][0]
      if data[i][j] > com_arr[i]
        result["#{i}-#{j}"] = true
        com_arr[i] = data[i][j]
      end
      i += 1
    end
    j += 1
  end
  # right
  j = data[0].length - 2
  com_arr = []
  while j > 0
    i = 1
    while i < (data.length - 1)
      com_arr[i] ||= data[i].last
      if data[i][j] > com_arr[i]
        result["#{i}-#{j}"] = true
        com_arr[i] = data[i][j]
      end
      i += 1
    end
    j -= 1
  end

  result.size + data[0].length * 2 + (data.length - 2) * 2
end

def score(data, i, j)
  result = 1
  # left
  k = 1
  count = 0
  while (j - k) >= 0
    count += 1
    if data[i][j - k] < data[i][j]
      k += 1
    else
      break
    end
  end
  result *= count
  # right
  k = 1
  count = 0
  while (j + k) < data[i].length
    count += 1
    if data[i][j + k] < data[i][j]
      k += 1
    else
      break
    end
  end
  result *= count
  # up
  k = 1
  count = 0
  while (i - k) >= 0
    count += 1
    if data[i - k][j] < data[i][j]
      k += 1
    else
      break
    end
  end
  result *= count
  # down
  k = 1
  count = 0
  while (i + k) < data.length
    count += 1
    if data[i + k][j] < data[i][j]
      k += 1
    else
      break
    end
  end
  result * count
end

def p2(data)
  result = 0
  i = 1
  while i < (data.length - 1)
    j = 1
    while j < (data[i].length - 1)
      s = score(data, i, j)
      result = s if s > result
      j += 1
    end
    i += 1
  end
  result
end

p p1(data)
p p2(data)
