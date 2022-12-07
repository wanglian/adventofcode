data = File.open('input/day07.txt').readlines.map(&:chomp)

dir_sizes = {}
path = []

data.each do |row|
  if row[0] == '$'
    case row[2, 2]
    when 'cd'
      if row[5, 2] == '..'
        key_tmp = path.join('-')
        tmp = path.pop
        key = path.join('-')
        unless dir_sizes[key][1].include?(tmp)
          dir_sizes[key][0] += dir_sizes[key_tmp][0]
          dir_sizes[key][1] << tmp
        end
      else
        path.push(row[5, row.length])
        dir_sizes[path.join('-')] ||= [0, []]
      end
    when 'ls'
      # do nothing
    end
  else
    if row[0, 3] == 'dir'
      # ignore
      # cmd, dir = row.split(' ')
      # dir_sizes[path.last][1] << dir
      # dir_sizes[path.last][1].uniq!
    else
      size, file = row.split(' ')
      dir_sizes[path.join('-')][0] += size.to_i
    end
  end
end

while tmp = path.pop
  key = path.join('-')
  dir_sizes[key][0] += dir_sizes[key + '-' + tmp][0] if path.last && !dir_sizes[key][1].include?(tmp)
end

def p1(dir_sizes)
  sum = 0
  dir_sizes.each { |dir, stat| sum += stat[0] if stat[0] <= 100000 }
  sum
end

def p2(dir_sizes)
  needed = dir_sizes['/'][0] - 40000000
  target = 70000000
  dir_sizes.each do |dir, stat|
    target = stat[0] if stat[0]> needed && stat[0] < target
  end
  target
end

p p1(dir_sizes)
p p2(dir_sizes)
