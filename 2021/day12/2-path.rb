file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   'start-A',
#   'start-b',
#   'A-c',
#   'A-b',
#   'b-d',
#   'A-end',
#   'b-end'
# ]

# data = [
#   'dc-end',
#   'HN-start',
#   'start-kj',
#   'dc-start',
#   'dc-HN',
#   'LN-dc',
#   'HN-end',
#   'kj-sa',
#   'kj-HN',
#   'kj-dc',
# ]

# data = [
#   'fs-end',
#   'he-DX',
#   'fs-he',
#   'start-DX',
#   'pj-DX',
#   'end-zg',
#   'zg-sl',
#   'zg-pj',
#   'pj-he',
#   'RW-he',
#   'fs-DX',
#   'pj-RW',
#   'zg-RW',
#   'start-pj',
#   'he-WI',
#   'zg-he',
#   'pj-fs',
#   'start-RW',
# ]

@routes = {}
data.map {|r| r.split('-')}.each do |d|
  if d[1] != 'start'
    @routes[d[0]] ||= []
    @routes[d[0]] << d[1]
  end
  if d[1] != 'end' && d[0] != 'start'
    @routes[d[1]] ||= []
    @routes[d[1]] << d[0]
  end
end
# p @routes

def can_track?(path, cur)
  if cur != 'end' && cur.downcase == cur
    small_counts = path.select{|e| e.downcase == e}.inject(Hash.new(0)){|h, e| h[e] += 1; h}
    small2 = small_counts.key 2
    count_cur = path.select{|e| e == cur}.size
    if small2
      small2 == cur ? false : count_cur < 1
    else
      count_cur <= 1
    end
  else
    true
  end
end

@paths = []
def track(path, cur)
  path << cur
  if cur == 'end'
    @paths << path
  else
    @routes[cur].select{|e| can_track? path, e}.map{|e| track(path.clone, e)}
  end
end

track([], 'start')
# @paths.each {|path| p path}
p @paths.count
