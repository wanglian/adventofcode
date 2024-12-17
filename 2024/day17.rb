require './utils.rb'

data = get_input("17")

def p1(data)
  # binding.break
  # ra, rb, rc = [729, 0, 0]
  # program = [0,1,5,4,3,0]
  ra, rb, rc = [37221270076916, 0, 0]
  program = [2,4,1,2,7,5,4,5,1,3,5,5,0,3,3,0]

  result = calc([ra, rb, rc], program)
  result.join(',')
end

def calc(registers, program)
  ra, rb, rc = registers
  result = []
  i = 0
  while i < (program.size-1)
    opcode = program[i]
    oprand = program[i+1]
    oprand_combo =
      case oprand
      when 4
        ra
      when 5
        rb
      when 6
        rc
      else
        oprand
      end

    case opcode
    when 0
      ra /= 2 ** oprand_combo
    when 1
      rb ^= oprand
    when 2
      rb = oprand_combo % 8
    when 3
      unless ra == 0
        i = oprand
        next
      end
    when 4
      rb ^= rc
    when 5
      result << oprand_combo % 8
    when 6
      rb = ra / 2**oprand_combo
    when 7
      rc = ra / 2**oprand_combo
    end
    i += 2
  end
  result
end

def p2(data)
  # program = [0,3,5,4,3,0]
  program = [2,4,1,2,7,5,4,5,1,3,5,5,0,3,3,0]

  a = 0
  while true
    p "=================> try #{a}"
    result = calc2(program, program.size-1, a)
    if result
      break
    else
      a += 1
    end
  end
  result
end

def calc2(program, i, a)
  ra = a << 3
  j = 0
  while j < 8
    rb = j
    raa = ra + rb
    rb ^= 2
    rc = raa >> rb
    rb ^= rc
    rb ^= 3
    if rb % 8 == program[i]
      p "#{i}: #{ra + j} - #{j}"
      if i == 0
        return ra + j
      else
        re = calc2(program, i-1, ra+j)
        return re if re
      end
    end
    j += 1
  end
  false
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
