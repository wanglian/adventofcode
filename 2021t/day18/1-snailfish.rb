file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

# data = [
#   '[1,1]',
#   '[2,2]',
#   '[3,3]',
#   '[4,4]',
#   '[5,5]',
#   '[6,6]'
# ]
# data = [
#   '[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]',
#   '[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]',
#   '[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]',
#   '[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]',
#   '[7,[5,[[3,8],[1,4]]]]',
#   '[[2,[2,2]],[8,[8,1]]]',
#   '[2,9]',
#   '[1,[[[9,3],9],[[9,0],[0,7]]]]',
#   '[[[5,[7,4]],7],1]',
#   '[[[[4,2],2],6],[8,7]]',
# ]
# data = [
#   '[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]',
#   '[[[5,[2,8]],4],[5,[[9,9],0]]]',
#   '[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]',
#   '[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]',
#   '[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]',
#   '[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]',
#   '[[[[5,4],[7,7]],8],[[8,3],8]]',
#   '[[9,3],[[9,9],[6,[4,9]]]]',
#   '[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]',
#   '[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]',
# ]

data = data.map {|row| eval(row)}

def magnitude(sum)
  l = sum[0].is_a?(Array) ? magnitude(sum[0]) : sum[0]
  r = sum[1].is_a?(Array) ? magnitude(sum[1]) : sum[1]
  3 * l + 2 * r
end

# p magnitude([[9,1],[1,9]]) # 129
# p magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]) # 3488

def set_first_left(sum, v)
  if sum[0].is_a?(Integer)
    sum[0] += v
  else
    set_first_left(sum[0], v)
  end
end

def set_first_right(sum, v)
  if sum[1].is_a?(Integer)
    sum[1] += v
  else
    set_first_right(sum[1], v)
  end
end

def depth(sum)
  dl = sum[0].is_a?(Array) ? depth(sum[0]) : 0
  dr = sum[1].is_a?(Array) ? depth(sum[1]) : 0
  [dl, dr].max + 1
end

def reduce(sum)
  stack_left, stack_right = [], []
  i = 0
  tmp = sum
  node = nil
  while true
    l = tmp[0]
    r = tmp[1]
    el, er = nil, nil

    if l.is_a?(Array) && depth(l) >= (4 - i)
      stack_right << tmp
      node = tmp
      tmp = l
      i += 1
      next
    end
    if r.is_a?(Array) && depth(r) >= (4 - i)
      stack_left << tmp
      node = tmp
      tmp = r
      i += 1
      next
    end
    
    if l.is_a?(Integer) &&  r.is_a?(Integer)
      if i >= 4
        # explode
        el, er = l, r
        if node[0].is_a?(Array)
          node[0] = 0
          # left
          snode = stack_left.pop
          if snode
            if snode[0].is_a?(Array)
              set_first_right snode[0], el
            else
              snode[0] += el
            end
          end
          # right
          if node[1].is_a?(Array)
            set_first_left node[1], er
          else
            node[1] += er
          end
        else
          node[0] += el
          # right
          node[1] = 0
          snode = stack_right.pop
          if snode
            if snode[1].is_a?(Array)
              set_first_left snode[1], er
            else
              snode[1] += er
            end
          end
        end
        break
      end
    end
    if l.is_a?(Array) && can_split?(l)
      stack_right << tmp
      node = tmp
      tmp = l
      next
    end
    if l.is_a?(Integer) && l > 9
      tmp[0] = [l/2, (l+1)/2]
      break
    end
    if r.is_a?(Array) && can_split?(r)
      stack_left << tmp
      node = tmp
      tmp = r
      next
    end
    if r.is_a?(Integer) && r > 9
      tmp[1] = [r/2, (r+1)/2]
      break
    end
  end
end

def can_split?(sum)
  re = sum[0].is_a?(Array) ? can_split?(sum[0]) : sum[0] > 9
  re ||= sum[1].is_a?(Array) ? can_split?(sum[1]) : sum[1] > 9
  re
end

def reduced?(sum)
  return false if depth(sum) > 4
  !can_split?(sum)
end

# data = [[[[[9,8],1],2],3],4]
# data = [7,[6,[5,[4,[3,2]]]]]
# data = [[6,[5,[4,[3,2]]]],1]
# data = [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]
# data = [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
# data = [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
# data = [[[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]], [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]]]
# data = [[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]], [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]]
# data = [[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]], [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]]
# data = [[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]], [7,[5,[[3,8],[1,4]]]]]
# data = [[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]], [[2,[2,2]],[8,[8,1]]]]
# data = [[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]], [2,9]]
# data = [[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]], [1,[[[9,3],9],[[9,0],[0,7]]]]]
# data = [[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]], [[[5,[7,4]],7],1]]
# data = [[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]], [[[[4,2],2],6],[8,7]]]

# data = [[[[4, 0], [5, 4]], [[7, 7], [6, 0]]], [17, [[11, 9], [11, 0]]]]
# p data
# reduce data
# p data

# while !reduced?(data)
#   reduce data
#   p data
# end

dd = data[0]
i = 1
while i < data.size
  tmp = [dd, data[i]]
  p tmp
  while !reduced?(tmp)
    reduce tmp
  end
  dd = tmp
  p "==> #{dd}"
  i += 1
end

p magnitude(dd)