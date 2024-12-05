require './utils.rb'

data = get_input("15")[0].split(',')

def p1(data)
  data.inject(0) do |sum, step|
    sum + calc_hash(step)
  end
end

def calc_hash(step)
  re = 0
  step.each_char do |c|
    re += c.ord
    re *= 17
    re %= 256
  end
  re
end

def p2(data)
  boxes = []
  data.each do |step|
    if step[-1] == '-'
      label = step.split('-')[0]
      i = calc_hash(label)
      boxes[i].delete_if {|len| len[0] == label} if boxes[i]
    else
      label, focal = step.split('=')
      i = calc_hash(label)
      boxes[i] ||= []
      update_box(boxes[i], label, focal.to_i)
    end
  end
  boxes.each_with_index.inject(0) do |sum, (lens, i)|
    # binding.break
    sum + if lens
      lens.each_with_index.inject(0) do |ss, (ll, j)|
        ss + (i+1) * (j+1) * ll[1]
      end
    else
      0
    end
  end
end

def update_box(box, label, focal)
  box.each do |len|
    len[1] = focal and return if len[0] == label
  end
  box << [label, focal]
end

p p1(data)
p p2(data)
