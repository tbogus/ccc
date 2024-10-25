require 'scanf'

n, = scanf("%d")
n.times do
  x,y,c = scanf("%d%d%d")
  # puts a*b/3
  # a*b/3
  raise "a*b/3 = #{x*y/3} != #{c}" if x*y/3 != c
  (1..c).each do |i|
    printf("%d %d %d%c", i, i, i, i%(x/3) == 0 ? "\n" : " ")
  end
end
