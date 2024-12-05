require './utils.rb'

data = get_input("07")

CARD = %w(2 3 4 5 6 7 8 9 T J Q K A)
def p1(data)
  data.collect do |row|
    row.strip.split(' ')
  end.sort do |r1, r2|
    h1 = r1[0]
    h2 = r2[0]
    th1 = get_type(h1)
    th2 = get_type(h2)
    if th1 == th2
      i = 0
      re = 0
      while i < 5
        p1 = CARD.index(h1[i])
        p2 = CARD.index(h2[i])
        if p1 == p2
          i += 1
        else
          re = p1 <=> p2
          break
        end
      end
      re
    else
      th1 <=> th2
    end
  end.each_with_index.inject(0) do |sum, (h, i)|
    sum + (i+1) * h[1].to_i
  end
end

def get_type(h)
  sh = h.split('').sort
  if sh.first == sh.last
    7
  elsif sh[0] == sh[3] || sh[1] == sh[4]
    6
  elsif (sh[0] == sh[2] && sh[3] == sh[4]) || (sh[0] == sh[1] && sh[2] == sh[4])
    5
  elsif sh[0] == sh[2] || sh[1] == sh[3] || sh[2] == sh[4]
    4
  else
    case sh.uniq.size
    when 3
      3
    when 4
      2
    when 5
      1
    else
      raise "not possible #{sh}"
    end
  end
end

CARD2 = %w(J 2 3 4 5 6 7 8 9 T Q K A)
def p2(data)
  data.collect do |row|
    row.strip.split(' ')
  end.sort do |r1, r2|
    h1 = r1[0]
    h2 = r2[0]
    th1 = get_type2(h1)
    th2 = get_type2(h2)
    if th1 == th2
      i = 0
      re = 0
      while i < 5
        p1 = CARD2.index(h1[i])
        p2 = CARD2.index(h2[i])
        if p1 == p2
          i += 1
        else
          re = p1 <=> p2
          break
        end
      end
      re
    else
      th1 <=> th2
    end
  end.each_with_index.inject(0) do |sum, (h, i)|
    sum + (i+1) * h[1].to_i
  end
end

def get_type2(h)
  cj = h.count('J')
  return 7 if cj >= 4

  sh = h.split('').sort
  re = if sh.first == sh.last # XXXXXX
    7
  elsif sh[0] == sh[3] || sh[1] == sh[4] # XXXXO, XOOOOO
    6
  elsif (sh[0] == sh[2] && sh[3] == sh[4]) || (sh[0] == sh[1] && sh[2] == sh[4]) # XXXOO XXOOO
    5
  elsif sh[0] == sh[2] || sh[1] == sh[3] || sh[2] == sh[4] # XXXOK XOOOK XOKKK
    4
  else
    case sh.uniq.size
    when 3 # XXOOK
      3
    when 4 # XXOKM
      2
    when 5 # XOKMI
      1
    else
      raise "not possible #{sh}"
    end
  end
  
  case cj
  when 0
    re
  when 1
    case re
    when 1
      2
    when 2
      4
    when 3
      5
    when 4
      6
    when 6
      7
    else
      raise "not possible #{sh}"
    end
  when 2
    case re
    when 2
      4
    when 3
      6
    when 5
      7
    else
      raise "not possible #{sh}"
    end
  when 3
    case re
    when 4
      6
    when 5
      7
    else
      raise "not possible #{sh}"
    end
  else
    raise "not possible #{sh}"
  end
end

p p1(data)
p p2(data)
