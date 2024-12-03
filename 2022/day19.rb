require './utils.rb'

data = get_input("19")

def parse(data)
  data.map do |row|
    row.split(':')[1].split('.').map do |s|
      s.scan(/\d+/).map(&:to_i)
    end
  end
end

blueprints = parse(data)
# p blueprints

def check_build(blueprint, count, type)
  case type
  when :ora
    count[0] / blueprint[0][0]
  when :cla
    count[0] / blueprint[1][0]
  when :obs
    [count[0] / blueprint[2][0], count[1] / blueprint[2][1]].min
  when :geo
    [count[0] / blueprint[3][0], count[2] / blueprint[3][1]].min
  end
end

# robots: [ore, cla, obs, geo]
# count: [ore, cla, obs, geo]

# def p1(blueprints)
#   result = blueprints.map.with_index { |bp, i| mine(bp) * (i+1) }
#   p result
#   result.inject { |sum, r| sum +r }
# end
def list_ora_robots(blueprint, robots=[0])
  m = 1
  count = 0
  while m < 24
    if count >= blueprint[0]
      n = count / blueprint[0]
      n.times { robots << m }
      count -= blueprint[0] * n
    end
    count += robots.size
    m += 1
  end
  robots
end

def list_cla_robots(blueprint, ora_robots)
  robots = []
  m = 1
  count = 0
  while m < 24
    if count >= blueprint[0]
      n = count / blueprint[0]
      n.times { robots << m }
      count -= blueprint[0] * n
    end
    ora_robots.each do |ora|
      count += 1 if ora < m
    end
    m += 1
  end
  robots
end

def list_obs_robots(blueprint, ora_robots, cla_robots)
  robots = []
  m = 1
  count_ora = 0
  count_cla = 0
  while m < 24
    if count_ora >= blueprint[0] && count_cla >= blueprint[1]
      n1 = count_ora / blueprint[0]
      n2 = count_cla / blueprint[1]
      n = [n1, n2].min
      n.times { robots << m }
      count_ora -= blueprint[0] * n
      count_cla -= blueprint[1] * n
    end
    ora_robots.each do |ora|
      count_ora += 1 if ora < m
    end
    cla_robots.each do |cla|
      count_cla += 1 if cla < m
    end
    m += 1
  end
  robots
end

def list_geo_robots(blueprint, ora_robots, obs_robots)
  robots = []
  m = 1
  count_ora = 0
  count_obs = 0
  while m < 24
    if count_ora >= blueprint[0] && count_obs >= blueprint[1]
      n1 = count_ora / blueprint[0]
      n2 = count_obs / blueprint[1]
      n = [n1, n2].min
      n.times { robots << m }
      count_ora -= blueprint[0] * n
      count_obs -= blueprint[1] * n
    end
    ora_robots.each do |ora|
      count_ora += 1 if ora < m
    end
    obs_robots.each do |obs|
      count_obs += 1 if obs < m
    end
    m += 1
  end
  robots
end

def probe(blueprint, robots, count, type="geo")
  case type
  when 'geo'
    pora = if count[0] >= blueprint[3][0]
      0
    else
      ((blueprint[3][0] - count[0]) / robots[0]).ceil
    end
    pobs = if count[2] >= blueprint[3][1]
      0
    elsif robots[2] == 0
      probe(blueprint, robots, count, 'obs') + blueprint[3][1]
    else
      ((blueprint[3][1] - count[2]) / robots[2]).ceil
    end
    [pora, pobs].max
  when 'obs'
    pora = if count[0] >= blueprint[2][0]
      0
    else
      ((blueprint[2][0] - count[0]) / robots[0]).ceil
    end
    pcla = if count[1] >= blueprint[2][1]
      0
    elsif robots[1] == 0
      probe(blueprint, robots, count, 'cla') + blueprint[2][1] / 2
    else
      ((blueprint[2][1] - count[1]) / robots[1]).ceil
    end
    [pora, pcla].max
  when 'cla'
    if count[0] >= blueprint[1][0] || (count[0] - count[1]) > 3
      0
    else
      ((blueprint[1][0] - count[0]) / robots[0]).ceil
    end
  end
end

@cache_r = {}
def mine(blueprint, robots=[1, 0, 0, 0], count=[0, 0, 0, 0], m=24)
  # if count[3] > 0
  #   p "minute #{m}"
  #   p robots, count
  #   binding.b
  # end
  # if count[2] > 0 && (!@cache_r['obs'] || @cache_r['obs'] < m)
  #   @cache_r['obs'] = m
  # end
  # if count[3] > 0 && (!@cache_r['geo'] || @cache_r['geo'] < m)
  #   @cache_r['geo'] = m
  # end
  # return 0 if robots[1] == 0 && robots[2] == 0 && robots[3] == 0 && m < (blueprint[2][1] + blueprint[3][1])
  # return 0 if robots[2] == 0 && robots[3] == 0 && m < blueprint[3][1] + 2
  # k = probe (blueprint, robots, count)
#   binding.b
  return 0 if robots[3] == 0 && m < probe(blueprint, robots, count)
  # p "minute #{m}"
  # p robots, count
  # binding.b
  if m == 0
    return count[3]
  end

  pre_count = count.clone
  n1 = check_build(blueprint, pre_count, :geo)
  if n1 > 0
    pre_count[0] -= blueprint[3][0]
    pre_count[2] -= blueprint[3][1]
  end
  n2 = check_build(blueprint, pre_count, :obs)
  n3 = check_build(blueprint, pre_count, :cla)
  n4 = check_build(blueprint, pre_count, :ora)

  robots.map.with_index { |r, k| count[k] += r }

  if n1 > 0
    robots[3] += 1
    count[0] -= blueprint[3][0]
    count[2] -= blueprint[3][1]
  end

  if (n2 + n3 + n4) > 0
    re = []
    m2 = [n2-1, 0].max
    (m2..n2).each do |n_obs|
      robots_obs = robots.clone
      robots_obs[2] += n_obs
      pre_count_1 = pre_count.clone
      pre_count_1[0] -= n_obs * blueprint[2][0]
      pre_count[1] -= n_obs * blueprint[2][1]
      count_obs = count.clone
      count_obs[0] -= n_obs * blueprint[2][0]
      count_obs[1] -= n_obs * blueprint[2][1]
      n3 = check_build(blueprint, pre_count_1, :cla)
      m3 = [n3-1, 0].max
      m3 = n3 if (robots[1] == 0 && (robots[0] - robots[1]) > 2) || (robots[1] > 0 && robots[0] / robots[1] > 2)
      # if robots[1] / robots[0] > 2
      #   m3 = 0
      #   n3 = 0
      # end
      (m3..n3).each do |n_cla|
        robots_cla = robots_obs.clone
        robots_cla[1] += n_cla
        pre_count_2 = pre_count_1.clone
        pre_count_2[0] -= n_cla * blueprint[1][0]
        count_cla = count_obs.clone
        count_cla[0] -= n_cla * blueprint[1][0]
        n4 = check_build(blueprint, pre_count_2, :ora)
        m4 = [n4-1, 0].max
        if (robots[1] == 0 && (robots[0] - robots[1]) > 2) || (robots[1] > 0 && robots[0] / robots[1] > 2)
          n4 = 0
          m4 = 0
        end
        
        (m4..n4).each do |n_ora|
          count_ora = count_cla.clone
          robots_ora = robots_cla.clone
          robots_ora[0] += n_ora
          count_ora[0] -= n_ora * blueprint[0][0]
          re << mine(blueprint, robots_ora, count_ora, m - 1)
        end
      end
    end
    return re.max
  else
    return mine(blueprint, robots, count, m - 1)
  end
end

# p blueprints
# p list_ora_robots(blueprints[0][0])
# p list_cla_robots(blueprints[0][1], [0])
# p list_obs_robots(blueprints[0][2], [0], [3, 5, 7])
# p list_geo_robots(blueprints[0][3], [0], [11, 15])
# p blueprints.map { |bp| mine(bp) }
with_time { p mine(blueprints[1]) }
# p mine([[3], [3], [2, 20], [2, 20]])
# p mine(blueprints[0], [1, 4, 2, 1], [4, 25, 7, 2], 20)
# with_time { p p1(blueprints) }
