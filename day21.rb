require './utils.rb'

data = get_input("21")

def calc(a, b, operation)
  eval "#{a} #{operation} #{b}"
end

def subscribe(monkey, target, job)
  @subscriptions[target] ||= {}
  @subscriptions[target][monkey] = job
end

def unsubscribe(monkey, target)
  @subscriptions[target]&.delete(monkey)
  @subscriptions.delete(target) if @subscriptions[target]&.empty?
end

def publish(monkey, number)
  return if @numbers[monkey]
  @numbers[monkey] = number
  return unless @subscriptions[monkey]
  @subscriptions[monkey].each do |m, job|
    m1, operation, m2 = job
    if @numbers[m1] && @numbers[m2]
      number = calc(@numbers[m1], @numbers[m2], operation)
      publish(m, number)
    end
    unsubscribe(m, monkey)
  end
end

def de_op1(a, operation, b)
  case operation
  when '+'
    [a, '-', b]
  when '-'
    [a, '+', b]
  when '*'
    [a, '/', b]
  when '/'
    [a, '*', b]
  end
end

def de_op2(a, operation, b)
  case operation
  when '+'
    [a, '-', b]
  when '-'
    [b, '-', a]
  when '*'
    [a, '/', b]
  when '/'
    [b, '/', a]
  end
end

def traverse(data, humn=false)
  data.each do |row|
    monkey, job = row.split(": ")
    next if humn && monkey == 'humn'
    number = job.scan(/\d+/)
    if number.empty?
      m1, operation, m2 = job.split(' ')
      if @numbers[m1] && @numbers[m2]
        number = calc(@numbers[m1], @numbers[m2], operation)
        publish(monkey, number)
      else
        subscribe(monkey, m1, [m1, operation, m2]) unless @numbers[m1]
        subscribe(monkey, m2, [m1, operation, m2]) unless @numbers[m2]
      end
    else
      publish(monkey, number.first.to_i)
    end
  end
end

def reverse(m)
  @subscriptions[m]&.each do |mm, op|
    m1, operation, m2 = op
    if mm == 'root'
      if m1 == m
        @mmm = [m1, @numbers[m2]]
      else
        @mmm = [m2, @numbers[m1]]
      end
    else
      reverse(mm)
      if m1 == m
        subscribe(m, mm, de_op1(mm, operation, m2))
      else
        subscribe(m, mm, de_op2(mm, operation, m1))
      end
    end
    unsubscribe(mm, m)
  end
end

def p1(data)
  @numbers = {}
  @subscriptions = {}
  traverse(data)
  @numbers['root']
end

def p2(data)
  @numbers = {}
  @subscriptions = {}
  traverse(data, true)

  reverse('humn')
  publish(@mmm[0], @mmm[1])
  @numbers['humn']
end


# part 1
with_time { p p1(data) }

# part 2
with_time { p p2(data) }
