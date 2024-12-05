require './utils.rb'

data = get_input("02")

def parse(data)
  data.collect do |row|
    row.split(":")[1].split(";").collect do |set|
      h = {}
      set.split(",").each do |d|
        re = d.strip.split(' ')
        h[re[1]] = re[0].to_i
      end
      h
    end
  end
end

data = parse(data)

def p1(data, total)
  data.each_with_index.inject(0) do |sum, (game, i)|
    possible = true
    game.each do |set|
      set.each do |k, v|
        if total[k] < v
          possible = false
          break
        end
      end
      break unless possible
    end
    possible ? sum + i + 1 : sum
  end
end

def p2(data)
  data.each_with_index.inject(0) do |sum, (game, i)|
    min = {"red" => 0, "green" => 0, "blue" => 0}
    game.each do |set|
      set.each do |k, v|
        min[k] = v if min[k] < v
      end
    end
    sum + min.values.inject(1) {|m, i| m * i}
  end
end

p p1(data, {"red" => 12, "green" => 13, "blue" => 14})
p p2(data)
