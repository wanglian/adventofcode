require './utils.rb'

data = get_input("09")[0].split('').map(&:to_i)

def p1(data)
  result = 0
  pos = 0
  moving = 0
  k = 0
  data.each_with_index do |v, i|
    # binding.break
    if free?(i)
      v.times do |j|
        if moving == 0
          moving, k = get_moving(data)
        end
        result += pos * (k / 2)
        pos += 1
        moving -= 1
      end
    else
      v.times do |j|
        result += pos * (i / 2)
        pos += 1
      end
    end
  end
  moving.times do |j|
    result += pos * (k / 2)
    pos += 1
  end
  result
end

def free?(i)
  i % 2 == 1
end

def get_moving(data)
  k = data.length-1
  if free?(k)
    data.pop
    k -= 1
  end
  [data.pop, k]
end

def p2(data)
  result = 0
  pos = 0
  moving = 0 # size
  moved = []
  data.each_with_index do |v, i|
    # binding.break
    # p [i, v]
    if free?(i)
      k = data.length - 1 # k/2 id
      while true
        break if k < i
        if moved.include?(k)
          k -= 2
          next
        end
        moving = data[k]
        if v >= moving
          v -= moving
          # p "move #{[k, moving]}"
          moving.times do |j|
            result += pos * (k / 2)
            pos += 1
            # p "pos: #{pos}"
          end
          moved << k
          k -= 2
          break if v == 0
        else
          # p "skipped"
        end
        k -= 2
      end
      pos += v
    else
      if moved.include?(i)
        # p "moved"
        pos += v
        next
      end
      # p "calc"
      v.times do |j|
        result += pos * (i / 2)
        pos += 1
      end
      # p "pos: #{pos}"
    end
  end
  result
end

# p p1(data)
p p2(data)
