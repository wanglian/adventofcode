require './utils.rb'

data = get_input("12")

def p1(data)
  data.inject(0) do |sum, row|
    group, damages = row.split(' ')
    group = group.split('')
    damages = damages.split(',').map(&:to_i)
    sum + check(group, damages)
  end
end

def check(group, damages)
  total_damages = damages.sum
  known_damages = group.count('#')
  unknow_damages = total_damages - known_damages
  unknow_spots = []
  group.each_with_index {|s, i| unknow_spots << i if s == '?'}
  unknow_spots.combination(unknow_damages).inject(0) do |sum, c|
    g = group.clone
    c.each {|i| g[i] = '#'}
    check_group(g, damages) ? sum + 1 : sum
  end
end

def check_group(group, damages)
  i = 0
  count = 0
  group.each do |g|
    case g
    when '#'
      count += 1
    else
      if count > 0
        return false unless count == damages[i]
        i += 1
        count = 0
      end
    end
  end
  if count > 0
    return false unless damages[i] == count
    i += 1
  end
  i == damages.size
end

def p2(data)
  data.inject(0) do |sum, row|
    group, damages = row.split(' ')
    group = group.split('')
    damages = damages.split(',').map(&:to_i)
    # unknow_damages = damages.sum - group.count('#')
    # c = check3(group, damages, unknow_damages)
    group = group + ['?'] + group
    damages = damages * 2
    p "#{group}: #{damages}"
    c = check4(group, damages)
    # p c
    sum + c
  end
end

def check4(group, damages)
  valid = valid?(group, damages)
  # p "#{group}: #{damages}- #{valid}"
  if valid
    if check_group(group, damages)
      # p "#{group}: #{damages}"
      1
    else
      i = group.index('?')
      if i.nil?
        # raise "#{group}: #{damages}"
        return 0
      end
      g1 = group.clone
      g1[i] = '#'
      g2 = group.clone
      g2[i] = '.'
      check4(g1, damages) + check4(g2, damages)
    end
  else
    0
  end
end

def valid?(group, damages)
  # return false if group.count('#') > damages.sum
  i = 0
  count = 0
  group.each do |g|
    case g
    when '?'
      return true if count == 0
      return true if count <= damages[i]
    when '#'
      count += 1
    else
      if count > 0
        # p count
        return false unless count == damages[i]
        i += 1
        count = 0
      end
    end
  end
  if count > 0
    return false unless damages[i] == count
    i += 1
  end
  i == damages.size
rescue => e
  # binding.break
  # p e.message
  false
end

def check3(group, damages, unknow_damages)
  unknow_spots = []
  group.each_with_index {|s, i| unknow_spots << i if s == '?'}
  valid = check_group_3(group, damages, unknow_damages)
  # p "#{group}: #{damages} : #{unknow_damages}- #{valid}"
  # binding.break
  if valid
    if unknow_spots.size > 0
      i = unknow_spots.first
      tmp1 = group.clone
      tmp1[i] = '#'
      tmp2 = group.clone
      tmp2[i] = '.'
      check3(tmp1, damages, unknow_damages-1) + check3(tmp2, damages, unknow_damages)
    else
      1
    end
  else
    0 
  end
rescue => e
  binding.break
end

def check_group_3(group, damages, unknow_damages)
  # p "#{group}: #{damages}"
  return false if group.count('?') < unknow_damages
  i = 0
  count = 0
  group.each do |g|
    case g
    when '?'
      return true # count == 0 || count == damages[i]
    when '#'
      count += 1
    else
      if count > 0
        # p count
        return false unless count == damages[i]
        i += 1
        count = 0
      end
    end
  end
  return damages[i] == count if count > 0
  # i == (damages.size-1)
  true
end

def check2(group, damages)
  total_damages = damages.sum
  known_damages = group.count('#')
  unknow_damages = total_damages - known_damages
  unknow_spots = []
  group.each_with_index {|s, i| unknow_spots << i if s == '?'}
  unknow_spots.combination(unknow_damages).inject(0) do |sum, c|
    g = group.clone
    c.each {|i| g[i] = '#'}
    if check_group(g, damages)
      gc = group.clone
      li = g.rindex('#') + 1
      gc.unshift('?') if li < g.size
      li += 1
      gc = g[li..] + gc if li < g.size
      fi = g.index('#') - 1
      gc << '?' if fi >= 0
      fi -= 1
      gc += g[0, fi + 1] if fi >= 0
      # p gc
      sum + check(gc, damages) ** 4
    else
      sum
    end
  end
end

with_time {p p1(data)}
with_time {p p2(data)}
