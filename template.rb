i = gets.chomp.to_i
res = []
i.times do
  word = gets.chomp

  res << ""
end

File.open("output1.txt", "w") do |file|
  res.each do |r|
    file.puts r
  end
end
