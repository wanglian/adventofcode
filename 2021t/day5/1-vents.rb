file = File.open 'input.txt'
data = file.readlines.map(&:chomp)

vents = {}
data.map do |row|
  s = row.split(" -> ").map {|d| d.split(',').map(&:to_i)} # 409,872 -> 409,963

  if s[0][0] == s[1][0]
    min = [s[0][1], s[1][1]].min
    max = [s[0][1], s[1][1]].max
    i = min
    while i <= max
      point = "#{s[0][0]}-#{i}"
      vents[point] ||= 0
      vents[point] += 1
      i += 1
    end
  elsif s[0][1] == s[1][1]
    min = [s[0][0], s[1][0]].min
    max = [s[0][0], s[1][0]].max
    i = min
    while i <= max
      point = "#{i}-#{s[0][1]}"
      vents[point] ||= 0
      vents[point] += 1
      i += 1
    end
  end
end

count = vents.select {|k, v| v > 1 }.size
p "Total: #{vents.size}"
p ">= 2: #{count}"
