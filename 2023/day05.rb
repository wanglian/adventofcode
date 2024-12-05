require './utils.rb'

data = get_input("05")

def p1(data)
  seeds = data[0].strip.split(":")[1].strip.split(" ").map(&:to_i)
  maps = []
  n = 0
  i = 3
  while i < data.length
    if data[i].strip.empty?
      n += 1
      i += 2
    else
      maps[n] ||= []
      maps[n] << data[i].strip.split(" ").map(&:to_i)
      i += 1
    end
  end

  seeds.map do |seed|
    n = 0
    result = seed
    while n < maps.length
      result = map(maps[n], result)
      n += 1
    end
    result
  end.min
end

def p2_force(data)
  seeds = data[0].strip.split(":")[1].strip.split(" ").map(&:to_i)
  maps = []
  n = 0
  i = 3
  while i < data.length
    if data[i].strip.empty?
      n += 1
      i += 2
    else
      maps[n] ||= []
      maps[n] << data[i].strip.split(" ").map(&:to_i)
      i += 1
    end
  end

  k = 0 # seeds index
  re = nil
  while k < (seeds.size - 1)
    p "#{seeds[k]} - #{seeds[k+1]}"
    m = 0 # seeds step
    while m < seeds[k+1]
      n = 0 # factors index
      result = seeds[k] + m
      while n < maps.length
        result = map(maps[n], result)
        n += 1
      end

      re = result if re.nil? || re > result
      m += 1
    end
    k += 2
  end
  re
end

def map(maps, mfrom)
  maps.each do |map|
    if mfrom >= map[1] && mfrom < (map[1] + map[2])
      return map[0] + mfrom - map[1]
    end
  end
  mfrom
end

def p2(data)
  seeds = data[0].strip.split(":")[1].strip.split(" ").map(&:to_i)
  maps = []
  n = 0
  i = 3
  while i < data.length
    if data[i].strip.empty?
      n += 1
      i += 2
    else
      maps[n] ||= []
      maps[n] << data[i].strip.split(" ").map(&:to_i)
      i += 1
    end
  end

  ranges = []
  k = 0 # seeds index
  while k < (seeds.size - 1)
    ranges << Range.new(seeds[k], seeds[k] + seeds[k+1] - 1)
    k += 2
  end

  maps.each do |map|
    ranges = calc_range(ranges, map)
  end

  ranges.collect {|range| range.min}.min
end

def calc_range(ranges, maps)
  result = []
  maps.each do |map|
    map_range = Range.new(map[1], map[1] + map[2], true)
    tmp = []
    diff = map[1] - map[0]
    ranges.each do |range|
      if range.min > map_range.max || range.max < map_range.min
        tmp << range
      elsif range.min >= map_range.min && range.max <= map_range.max
        result << Range.new(range.min - diff, range.max - diff)
      elsif range.min < map_range.min && range.max > map_range.max
        result << Range.new(map_range.min - diff, map_range.max - diff)
        tmp << Range.new(range.min, map_range.min-1)
        tmp << Range.new(map_range.max+1, range.max)
      elsif range.min < map_range.min
        result << Range.new(map_range.min - diff, range.max - diff)
        tmp << Range.new(range.min, map_range.min-1)
      else # range[1] >= max
        result << Range.new(range.min - diff, map_range.max - diff)
        tmp << Range.new(map_range.max+1, range.max)
      end
    end
    ranges = tmp
  end

  result + ranges
end

p p1(data)
p p2(data)
