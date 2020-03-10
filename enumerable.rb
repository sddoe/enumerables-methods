#!/usr/bin/env ruby

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    test_class = self.class
    arr = if test_class == Array
            self
          elsif test_class == Range
            to_a
          else
            flatten
          end

    while i < arr.length
      if test_class == Hash
        yield(arr[i], arr[i + 1])
        i += 2
      else
        yield(arr[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    arr = self.class == Array ? self : to_a

    while i < length
      yield(arr[i], i)
      i += 1
    end
  end

  def my_select
    return to_enum unless block_given?

    arr = self.class == Array ? [] : {}

    if arr.class == Array
      my_each { |n| arr.push(n) if yield(n) }
    else
      my_each { |key, value| arr[key] = value if yield(key, value) }
    end

    arr
  end

  def my_all?(parameter = nil)
    return true if (self.class == Array && count.zero?) || (!block_given? && parameter.nil? && !include?(nil))

    return false unless block_given? || !parameter.nil?

    bool = true
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = false unless yield(n)
        elsif parameter.class == Regexp
          bool = false unless n.match(parameter)
        elsif parameter.class <= Numeric
          bool = false unless n == parameter
        else
          bool = false unless n.class <= parameter
        end
        break unless bool
      end
    else
      my_each { |key, value| bool = false unless yield(key, value) }
    end

    bool
  end

  def my_any?(parameter = nil)
    return false if (self.class == Array && count.zero?) || (!block_given? && parameter.nil? && !include?(true))

    return true unless block_given? || !parameter.nil?

    bool = false
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = true if yield(n)
        elsif parameter.class == Regexp
          bool = true if n.match(parameter)
        elsif parameter.class <= String
          bool = true if n == parameter
        elsif n.class <= parameter
          bool = true
        end
      end
    else
      my_each { |key, value| bool = true if yield(key, value) }
    end

    bool
  end

  def my_none?(parameter = nil)
    return true if (self.class == Array && count.zero?) || (self[0].nil? && !include?(true))

    return false unless block_given? || !parameter.nil?

    bool = true
    if self.class == Array
      my_each do |n|
        if block_given?
          bool = false if yield(n)
        elsif parameter.class == Regexp
          bool = false if n.match(parameter)
        elsif parameter.class <= Numeric
          bool = false if n == parameter
        elsif n.class <= parameter
          bool = false
        end
        break unless bool
      end
    else
      my_each do |key, value| 
        bool = false if yield(key, value) 
        break unless bool 
      end
    end

    bool
  end

  def my_count(parameter = nil)
    counter = 0

    if block_given?
      if self.class == Array
        my_each { |n| counter += 1 if yield(n) }
      else
        my_each { |key,value| counter += 1 if yield(key, value) }
      end
    elsif !block_given? && parameter.nil?
      return length
    elsif !block_given? && !parameter.nil?
      my_each { |n| counter += 1 if n == parameter }
    end

    counter
  end

  def my_map
    return to_enum unless block_given?

    arr = []
    if self.class == Array
      my_each {|n| arr << yield(n)}
    else
      my_each { |key, value| arr << yield(key, value) }
    end

    arr
  end

  def my_inject(symbol = nil, initial = nil)
    if symbol.class != Symbol
      temp = symbol
      symbol = initial
      initial = temp
    end

    provided = false
    provided = true unless initial.nil?
    counter = initial || first
    case symbol
    when :+
      if !provided
        drop(1).my_each { |n| counter += n }
      else
        my_each { |n| counter += n }
      end
    when :*
      if !provided
        drop(1).my_each { |n| counter *= n }
      else
        my_each { |n| counter *= n }
      end
    when :/
      if !provided
        drop(1).my_each { |n| counter /= n }
      else
        my_each { |n| counter /= n }
      end
    when :-
      if !provided
        drop(1).my_each { |n| counter -= n }
      else
        my_each { |n| counter -= n }
      end
    when :**
      if !provided
        drop(1).my_each { |n| counter **= n }
      else
        my_each { |n| counter **= n }
      end
    else
      if !provided
        drop(1).my_each { |n| counter = yield(counter, n) }
      else
        my_each { |n| counter = yield(counter, n) }
      end
    end
    counter
  end
end

arr = [1, 2, 3, 4, 5]
hash = {a: 1, b: 2, c: 3}
arr_words = %w(door bottle chair cat)

puts arr.my_each {|n| print n}
puts hash.my_each {|key, value| puts "Key: #{key}, Value: #{value}"}
puts arr.each.class == arr.my_each.class

puts

puts arr.my_each_with_index {|n,index| puts "Index is #{index} and element is #{n}"}
puts hash.my_each_with_index {|n, index| puts "Index is: #{index} and element is: #{n}"}
puts arr.each_with_index.class == arr.my_each_with_index.class

puts

puts arr.my_select(&:odd?)
puts hash.my_select {|key,value| value == 2}

puts

puts arr_words.my_all? {|word| word.length >= 3}
puts arr_words.my_all? {|word| word.length >= 4}
puts arr_words.my_all?(/c/)
puts arr.my_all?(Numeric)

puts

puts arr_words.my_any? {|word| word.length >= 3}
puts arr_words.my_any? {|word| word.length >= 4}
puts arr_words.my_any?(/s/)
puts arr.my_any?(Integer)

puts

puts arr_words.my_none? {|word| word.length == 3}
puts arr_words.my_none? {|word| word.length >= 6}
puts arr_words.my_none?(/f/)
puts arr.my_none?(Float)

puts

puts arr.my_count(1)
puts arr.my_count {|n| n > 2}
puts hash.my_count {|key,value| value.odd?}

puts

print arr.my_map {|n| n*2}
puts
print hash.my_map {|key,value| [key,value]}

puts
puts

puts arr.my_inject {|sum, n| sum + n}
puts arr.my_inject(1) {|pro, n| pro * n}
longest = arr_words.my_inject {|counter,word| counter.length > word.length ? counter : word}
puts longest

puts 

def multiply_els(arr)
  arr.my_inject do |counter, n|
    counter * n
  end
end

puts multiply_els(arr).to_s

puts

test_proc = proc {|n| n + 5}

puts arr.my_map(&test_proc).to_s