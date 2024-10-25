require 'scanf'

n, = scanf("%d")
n.times do
  a,b = scanf("%d%d")
  puts a*b/3
end
