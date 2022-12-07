data = File.open('input/day07.txt').readlines.map(&:chomp)

SIZE_LIMIT = 100000
SPACE_TOTAL = 70000000
SPACE_NEEDED = 30000000

def path_key(path, dir = nil)
  # use full path as key
  key = path.join('/')
  dir ? [key, dir].join('/') : key
end

def parse(data)
  dir_sizes = {}
  path = []

  data.each do |row|
    if row[0] == '$'
      case row[2, 2]
      when 'cd'
        if row[5, 2] == '..'
          # $ cd ..
          tmp = path.pop
          dir_sizes[path_key(path)] += dir_sizes[path_key(path, tmp)]
        else
          # $ cd dpgwtwp
          path.push(row[5, row.length])
          dir_sizes[path_key(path)] ||= 0
        end
      when 'ls'
        # do nothing
      end
    else
      if row[0, 3] == 'dir'
        # ignore
      else
        # 140007 jstfcllw.tdd
        size, file = row.split(' ')
        dir_sizes[path_key(path)] += size.to_i
      end
    end
  end

  while tmp = path.pop
    dir_sizes[path_key(path)] += dir_sizes[path_key(path, tmp)] if path.last
  end

  dir_sizes
end

def p1(dir_sizes)
  dir_sizes.inject(0) do |sum, dir_size|
    dir_size[1] <= SIZE_LIMIT ? sum + dir_size[1] : sum
  end
end

def p2(dir_sizes)
  used = dir_sizes['/']
  left = SPACE_TOTAL - used
  diff = SPACE_NEEDED - left
  dir_sizes.inject(SPACE_TOTAL) do |target, dir_size|
    size = dir_size[1]
    size > diff && size < target ? size : target
  end
end

dir_sizes = parse(data)
p p1(dir_sizes)
p p2(dir_sizes)
