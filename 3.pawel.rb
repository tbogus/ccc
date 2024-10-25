require 'scanf'

n, = scanf("%d")
n.times do
  x,y,c = scanf("%d%d%d")
  # puts a*b/3
  # a*b/3
  raise "a*b/3 = #{x*y/3} != #{c}" if x*y/3 != c
  i = 1
  while (y >= 3) 
    puts ([(i...(i+x)).to_a.join(" ")]*3).join("\n")
    i += x
    y -= 3
  end
  while (y > 0)
    (0...(x/3)).each do |j|
      printf("%d %d %d ", i+j, i+j, i+j)
    end
    puts((["0"] * (x%3)).join(" "))
    i += x/3
    y -= 1
  end
end
