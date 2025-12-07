require './utils.rb'

data = get_input("07").map { |row| row.split("") }

def p1(data)
  # binding.break
  beams = [data[0].index("S")]
  result = 0
  i = 1
  while i < data.size
    row = data[i]
    tmp = []
    beams.each do |b|
      if row[b] == '^'
        result += 1
        tmp << b - 1
        tmp << b + 1
      else
        tmp << b
      end
    end
    beams = tmp.uniq
    i += 1
  end
  result
end

def p2(data)
  beams = {data[0].index("S") => 1}
  i = 1
  while i < data.size
    row = data[i]
    tmp = {}
    beams.keys.each do |b|
      if row[b] == '^'
        tmp[b-1] ||= 0
        tmp[b-1] += beams[b]
        tmp[b+1] ||= 0
        tmp[b+1] += beams[b]
      else
        tmp[b] ||= 0
        tmp[b] += beams[b]
      end
    end
    beams = tmp
    i += 1
  end
  beams.values.sum
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
