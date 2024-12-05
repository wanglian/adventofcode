file = File.open 'input.txt'

data = [
  'v...>>.vv>',
  '.vv>>.vv..',
  '>>.>v>...v',
  '>>v>>.>.v.',
  'v>v.vv.v..',
  '>.>>..v...',
  '.vv..>.>v.',
  'v.v..>>v.v',
  '....v..v.>',
]

data = file.readlines.map(&:chomp)

def move_right(data)
  count = 0
  data.each do |row|
    l = row.length
    i = 0
    v0 = row[0]
    while i < l
      c = row[i]
      if c == '>'
        ni = i+1
        vni = if ni == l
          v0
        else
          row[ni]
        end
        if vni == '.'
          row[i] = '.'
          row[ni % l] = '>'
          count += 1
          i += 2
        else
          i += 1
        end
      else
        i += 1
      end
    end
  end
  count
end

def move_down(data)
  count = 0
  r = data.size
  l = data[0].length
  j = 0
  v0 = data[0].clone
  while j < l
    i = 0
    while i < r
      c = data[i][j]
      if c == 'v'
        ni = i+1
        vni = if ni == r
          v0[j]
        else
          data[ni][j]
        end
        if vni == '.'
          data[i][j] = '.'
          data[ni % r][j] = 'v'
          count += 1
          i += 2
        else
          i += 1
        end
      else
        i += 1
      end
    end
    j += 1
  end
  count
end

def move(data)
  c1 = move_right data
  c2 = move_down data
  c1 + c2
end

def pp(data)
  p '=='
  data.each do |row|
    p row
  end
end

pp data
step = 0
while true
  count = move data
  step += 1
  p "step #{step}: #{count}"
  # pp data
  break if count == 0
end
p step
# pp data
