require './utils.rb'

data = get_input("08").map { |row| row.split('') }

def p1(data)
  # binding.break
  frequencies = {}
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      unless v == '.'
        frequencies[v] ||= []
        frequencies[v] << [i, j]
      end
    end
  end

  mx, my = data.size, data[0].size
  results = {}
  frequencies.each do |f, locations|
    locations.each_with_index do |l1, i|
      j = i+1
      x1, y1 = l1
      while j<locations.size
        x2, y2 = locations[j]
        xa, ya = 2*x1-x2, 2*y1-y2
        results[[xa, ya]] = true if xa >=0 && xa < mx && ya >= 0 && ya < my
        xa, ya = 2*x2-x1, 2*y2-y1
        results[[xa, ya]] = true if xa >=0 && xa < mx && ya >= 0 && ya < my
        j += 1
      end
    end
  end
  results.keys.count
end

def p2(data)
  frequencies = {}
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      unless v == '.'
        frequencies[v] ||= []
        frequencies[v] << [i, j]
      end
    end
  end

  mx, my = data.size, data[0].size
  results = {}
  frequencies.each do |f, locations|
    locations.each_with_index do |l1, i|
      results[l1] = true
      j = i+1
      x1, y1 = l1
      while j<locations.size
        x2, y2 = locations[j]
        k = 1
        while true
          xa, ya = x1-(x2-x1)*k, y1-(y2-y1)*k
          if xa >=0 && xa < mx && ya >= 0 && ya < my
            results[[xa, ya]] = true
          else
            break
          end
          k += 1
        end
        k = 1
        while true
          xa, ya = x2+(x2-x1)*k, y2+(y2-y1)*k
          if xa >=0 && xa < mx && ya >= 0 && ya < my
            results[[xa, ya]] = true
          else
            break
          end
          k += 1
        end
        j += 1
      end
    end
  end
  results.keys.count
end

p p1(data)
p p2(data)
