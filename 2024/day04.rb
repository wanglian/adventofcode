require './utils.rb'

data = get_input("04").map { |row| row.split('') }

def p1(data)
  # binding.break
  rows = data.length
  columns = data[0].length
  k = 4
  result = 0
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      next unless v == 'X'
      # right
      if j <= (columns - k)
        result += 1 if match(row[j+1], row[j+2], row[j+3])
        # right up
        if i >= 3
          result += 1 if match(data[i-1][j+1], data[i-2][j+2], data[i-3][j+3])
        end
        # right down
        if i <= (rows - k)
          result += 1 if match(data[i+1][j+1], data[i+2][j+2], data[i+3][j+3])
        end
      end
      # left
      if j >= 3
        result += 1 if match(row[j-1], row[j-2], row[j-3])
        # left up
        if i >= 3
          result += 1 if match(data[i-1][j-1], data[i-2][j-2], data[i-3][j-3])
        end
        # left down
        if i <= (rows - k)
          result += 1 if match(data[i+1][j-1], data[i+2][j-2], data[i+3][j-3])
        end
      end
      # down
      if i <= (rows - k)
        result += 1 if match(data[i+1][j], data[i+2][j], data[i+3][j])
      end
      # up
      if i >= 3
        result += 1 if match(data[i-1][j], data[i-2][j], data[i-3][j])
      end
    end
  end
  result
end

def match(v1, v2, v3)
  v1 == 'M' && v2 == 'A' && v3 == 'S'
end

def p2(data)
  rows = data.length
  columns = data[0].length
  k = 3
  result = 0
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      next unless v == 'M'
      # right
      if i >= (k-1) && j <= (columns-k)
        result += 1 if match2(row[j+2], data[i-1][j+1], data[i-2][j], data[i-2][j+2])
      end
      # up
      if i >= (k-1) && j >= (k-1)
        result += 1 if match2(data[i-2][j], data[i-1][j-1], row[j-2], data[i-2][j-2])
      end
      # left
      if i <= (rows-k) && j >= (k-1)
        result += 1 if match2(row[j-2], data[i+1][j-1], data[i+2][j], data[i+2][j-2])
      end
      # down
      if i <= (rows-k) && j <= (columns-k)
        result += 1 if match2(data[i+2][j], data[i+1][j+1], data[i+2][j+2], row[j+2])
      end
    end
  end
  result
end

def match2(v1, v2, v3, v4)
  v1 == 'M' && v2 == 'A' && v3 == 'S' && v4 == 'S'
end

p p1(data)
p p2(data)
