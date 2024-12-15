require './utils.rb'

data = get_input("15")

def parse(data)
  positions = []
  moves = []
  is_position = true
  data.each_with_index do |row, i|
    if row.empty?
      is_position = false
    else
      row = row.split('')
      if is_position
        positions[i] = row
      else
        moves += row
      end
    end
  end
  [positions, moves]
end

def p1(data)
  positions, moves = parse(data)
  x, y = initial_position(positions)
  mx, my = positions.size, positions[0].size

  # binding.break
  moves.each do |move|
    case move
    when '>'
      k = y + 1
      while k < my
        case positions[x][k]
        when '#'
          break
        when 'O'
          k += 1
        when '.'
          # move
          while k > y
            positions[x][k] = positions[x][k-1]
            positions[x][k-1] = '.'
            k -= 1
          end
          y += 1
          break
        else
          raise "wrong position: #{positions[x][k]}"
        end
      end
    when 'v'
      k = x + 1
      while k < mx
        case positions[k][y]
        when '#'
          break
        when 'O'
          k += 1
        when '.'
          # move
          while k > x
            positions[k][y] = positions[k-1][y]
            positions[k-1][y] = '.'
            k -= 1
          end
          x += 1
          break
        else
          raise "wrong position: #{positions[k][y]}"
        end
      end
    when '<'
      k = y - 1
      while k > 0
        case positions[x][k]
        when '#'
          break
        when 'O'
          k -= 1
        when '.'
          # move
          while k < y
            positions[x][k] = positions[x][k+1]
            positions[x][k+1] = '.'
            k += 1
          end
          y -= 1
          break
        else
          raise "wrong position: #{positions[x][k]}"
        end
      end
    when '^'
      k = x - 1
      while k > 0
        # binding.break
        case positions[k][y]
        when '#'
          break
        when 'O'
          k -= 1
        when '.'
          # move
          while k < x
            positions[k][y] = positions[k+1][y]
            positions[k+1][y] = '.'
            k += 1
          end
          x -= 1
          break
        else
          raise "wrong position: #{positions[k][y]}"
        end
      end
    else
      raise "wrong move: #{move}"
    end
  end

  result = 0
  positions.each_with_index do |row, i|
    row.each_with_index do |v, j|
      result += calc([i,j]) if v == 'O'
    end
  end
  result
end

def calc(pos)
  x, y = pos
  100 * x + y
end

def initial_position(positions)
  positions.each_with_index do |row, i|
    row.each_with_index do |v, j|
      return [i, j] if v == '@'
    end
  end
end

def p2(data)
  positions, moves = parse(data)
  positions = new_map(positions)

  x, y = initial_position(positions)
  mx, my = positions.size, positions[0].size

  moves.each do |move|
    # p "#{[x, y]} #{move}"
    case move
    when '>'
      k = y + 1
      while k < my
        case positions[x][k]
        when '#'
          break
        when '['
          k += 2
        when '.'
          # move
          while k > y
            positions[x][k] = positions[x][k-1]
            positions[x][k-1] = '.'
            k -= 1
          end
          y += 1
          break
        else
          raise "wrong position: #{positions[x][k]}"
        end
      end
    when 'v'
      kx = x + 1
      tmp = {}
      tmp[x] = [y]
      while kx < mx
        # p tmp
        # binding.break
        can_move = true
        stop = false
        tmp[kx-1].each do |ky|
          case positions[kx][ky]
          when '#'
            can_move = false
            stop = true
          when '['
            tmp[kx] ||= []
            tmp[kx] << ky
            tmp[kx] << ky + 1 if ky < (my - 1)
            tmp[kx].uniq!
            can_move = false
          when ']'
            tmp[kx] ||= []
            tmp[kx] << ky
            tmp[kx] << ky - 1 if ky > 0
            tmp[kx].uniq!
            can_move = false
          when '.'

          else
            raise "wrong position: #{positions[kx][ky]}"
          end
        end
        break if stop || can_move
        kx += 1
      end
      if can_move
        while kx > x
          tmp[kx-1].each do |ky|
            positions[kx][ky] = positions[kx-1][ky]
            positions[kx-1][ky] = '.'
          end
          kx -= 1
        end
        x += 1
      end
    when '<'
      k = y - 1
      while k > 0
        case positions[x][k]
        when '#'
          break
        when ']'
          k -= 2
        when '.'
          # move
          while k < y
            positions[x][k] = positions[x][k+1]
            positions[x][k+1] = '.'
            k += 1
          end
          y -= 1
          break
        else
          raise "wrong position: #{positions[x][k]}"
        end
      end
    when '^'
      kx = x - 1
      tmp = {}
      tmp[x] = [y]
      while kx > 0
        # p tmp
        # binding.break
        can_move = true
        stop = false
        tmp[kx+1].each do |ky|
          case positions[kx][ky]
          when '#'
            can_move = false
            stop = true
          when '['
            tmp[kx] ||= []
            tmp[kx] << ky
            tmp[kx] << ky + 1 if ky < (my - 1)
            tmp[kx].uniq!
            can_move = false
          when ']'
            tmp[kx] ||= []
            tmp[kx] << ky
            tmp[kx] << ky - 1 if ky > 0
            tmp[kx].uniq!
            can_move = false
          when '.'

          else
            raise "wrong position: #{positions[kx][ky]}"
          end
        end
        break if stop || can_move
        kx -= 1
      end
      if can_move
        while kx < x
          tmp[kx+1].each do |ky|
            positions[kx][ky] = positions[kx+1][ky]
            positions[kx+1][ky] = '.'
          end
          kx += 1
        end
        x -= 1
      end
    else
      raise "wrong move: #{move}"
    end
    # positions.each { |row| p row }
  end

  result = 0
  positions.each_with_index do |row, i|
    row.each_with_index do |v, j|
      result += calc([i,j]) if v == '['
    end
  end
  result
end

def new_map(positions)
  new_positions = []
  positions.each_with_index do |row, i|
    new_row = []
    row.each do |v|
      case v
      when '#'
        new_row << '#'
        new_row << '#'
      when 'O'
        new_row << '['
        new_row << ']'
      when '.'
        new_row << '.'
        new_row << '.'
      when '@'
        new_row << '@'
        new_row << '.'
      else
        raise "wrong"
      end
    end
    new_positions[i] = new_row
  end
  new_positions
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
