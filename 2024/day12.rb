require './utils.rb'

data = get_input("12").map { |row| row.split('') }

def p1(data)
  # binding.break
  regions = {}
  plot_regions = {}
  mi, mj = data.size-1, data[0].size-1
  k = 1
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      region = nil
      n = 0 # neiboughers
      if i > 0
        if data[i-1][j] == v
          region = plot_regions[[i-1, j]]
          n += 1
        end
      end
      if j > 0
        if data[i][j-1] == v
          region2 = plot_regions[[i, j-1]]
          if region && region2 && region != region2
            # p "#{region} - #{region2}"
            # merge
            region2_plots = plot_regions.each { |k, v| plot_regions[k] = region if v == region2 }
            regions[region] = merge_regions(regions[region], regions[region2])
            regions.delete(region2)
          end
          region ||= region2
          n += 1
        end
      end
      unless region
        region = "#{v}#{k}"
        k += 1
      end
      plot_regions[[i, j]] = region
      regions[region] = cal_region(regions[region], n)
    end
  end
  # p regions
  regions.values.inject(0) { |sum, r| sum + r[0] * r[1] }
end

def cal_region(region, n)
  area, perimeter = region || [0, 0]
  area += 1
  case n
  when 0
    perimeter += 4
  when 1
    perimeter += 2
  end
  [area, perimeter]
end

def merge_regions(region1, region2)
  [region1[0] + region2[0], region1[1] + region2[1]]
end

def p2(data)
  regions = {}
  plot_regions = {}
  mi, mj = data.size-1, data[0].size-1
  k = 1
  data.each_with_index do |row, i|
    row.each_with_index do |v, j|
      region = nil
      p1, p2, p3, p4 = false, false, false, false # neiboughers
      if i > 0
        if data[i-1][j] == v
          p3 = true
          region = plot_regions[[i-1, j]]
        end
        if j > 0
          if data[i-1][j-1] == v
            p2 = true
          end
        end
        if j < mj
          if data[i-1][j+1] == v
            p4 = true
          end
        end
      end
      if j > 0
        if data[i][j-1] == v
          p1 = true
          region2 = plot_regions[[i, j-1]]
          if region && region2 && region != region2
            # merge
            region2_plots = plot_regions.each { |k, v| plot_regions[k] = region if v == region2 }
            regions[region] = merge_regions(regions[region], regions[region2])
            regions.delete(region2)
          end
          region ||= region2
        end
      end
      unless region
        region = "#{v}#{k}"
        k += 1
      end
      plot_regions[[i, j]] = region
      regions[region] = cal_region2(regions[region], p1, p2, p3, p4)
    end
  end
  # p regions
  regions.values.inject(0) { |sum, r| sum + r[0] * r[1] }
end

def cal_region2(region, p1, p2, p3, p4)
  area, perimeter = region || [0, 0]
  area += 1
  if p1
    if p3
      perimeter -= 2 unless p4
    elsif p2
      perimeter += 2
    end
  else
    if p3
      if p2 && p4
        perimeter += 4
      elsif p2 || p4
        perimeter += 2
      end
    else
      perimeter += 4
    end
  end

  [area, perimeter]
end

p "Problem 1:"
with_time { p p1(data) }
p "Problem 2:"
with_time { p p2(data) }
