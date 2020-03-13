arr = [1, 2, 3, 4, 5]
arr_words = %w[door bottle chair cat]

puts(arr.my_each { |n| print n })
puts arr.each.class == arr.my_each.class

puts

puts(arr.my_each_with_index { |n, index| puts "Index is #{index} and element is #{n}" })
puts arr.each_with_index.class == arr.my_each_with_index.class

puts

puts arr.my_select(&:odd?)

puts

puts(arr_words.my_all? { |word| word.length >= 3 })
puts(arr_words.my_all? { |word| word.length >= 4 })
puts arr_words.my_all?(/t/)
puts arr.my_all?(Numeric)

puts

puts(arr_words.my_any? { |word| word.length >= 3 })
puts(arr_words.my_any? { |word| word.length >= 4 })
puts arr_words.my_any?(/s/)
puts arr.my_any?(Float)

puts

puts(arr_words.my_none? { |word| word.length == 3 })
puts(arr_words.my_none? { |word| word.length >= 6 })
puts arr_words.my_none?(/f/)
puts arr.my_none?(Float)

puts

puts arr.my_count(1)
puts(arr.my_count { |n| n > 2 })
puts [1, 2, 3].my_count

puts

print(arr.my_map { |n| n * 2 })

puts
puts

puts(arr.my_inject { |sum, n| sum + n })
puts arr.my_inject(1) { |pro, n| pro * n }
longest = arr_words.my_inject { |counter, word| counter.length > word.length ? counter : word }
puts longest

puts

def multiply_els(arr)
  arr.my_inject do |counter, n|
    counter * n
  end
end

puts multiply_els(arr).to_s

puts

test_proc = proc { |n| n > 5 }

puts arr.my_map(&test_proc).to_s
puts arr.my_map { |n| n < 5 }.to_s
