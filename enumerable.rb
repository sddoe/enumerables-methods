module Enumerable
  def my_each(&block)
    size.times { |n| block.call(self[n]) } and return self if block
    to_enum
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    arr = self.class == Array ? self : to_a
    while i < arr.length
      yield(arr[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    resp = []
    arr = self.class == Array ? self : to_a
    arr.my_each { |n| resp.push(n) if yield(n) }
    resp
  end

  def my_all?(parameter = nil, &block)
    bool = true
    if block
      my_each { |n| bool = false unless block.call(n) }
    elsif parameter.nil?
      my_each { |n| bool = false unless n }
    else
      my_each { |n| bool = false unless parameter === n } # rubocop:disable Style/CaseEquality
      to_enum
    end
    bool
  end

  def my_any?(parameter = nil, &block)
    bool = false
    if block
      my_each { |n| bool = true if block.call(n) }
    elsif parameter.nil?
      my_each { |n| bool = true if n }
    else
      my_each { |n| bool = true if parameter === n } # rubocop:disable Style/CaseEquality
      to_enum
    end
    bool
  end

  def my_none?(parameter = nil, &block)
    bool = true
    if block
      my_each { |n| bool = false if block.call(n) }
    elsif parameter.nil?
      my_each { |n| bool = false if n }
    else
      my_each { |n| bool = false if parameter === n } # rubocop:disable Style/CaseEquality
      to_enum
    end
    bool
  end

  def my_count(parameter = nil, &block)
    counter = 0
    if block_given?
      my_each { |n| counter += 1 if block.call(n) }
    elsif parameter.nil?
      my_each { |_n| counter += 1 if item }
    else
      my_each { |n| counter += 1 if parameter === n } # rubocop:disable Style/CaseEquality
      to_enum
    end
    counter
  end

  def my_map
    arr = []
    my_each { |n| arr << yield(n) if yield(n) != 0 } and return arr if block_given?
    to_enum
  end

  def my_inject(counter = nil, oper = nil, &block)
    if !block
      if oper.nil?
        oper = counter
        counter = nil
      end
      oper.to_sym
      each { |n| counter = counter.nil? ? n : counter.send(oper, n) }
    else
      each { |n| counter = counter.nil? ? n : block.call(counter, n) }
    end
    counter
  end
end

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

test_proc = proc { |n| n + 5 }

puts arr.my_map(&test_proc).to_s
