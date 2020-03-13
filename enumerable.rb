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
      my_each { |n| counter += 1 if n }
    else
      my_each { |n| counter += 1 if parameter === n } # rubocop:disable Style/CaseEquality
      to_enum
    end
    counter
  end

  def my_map(*block)
    return to_enum(:my_map) unless block_given?

    arr = []
    if !block[0].nil?
      size.times { |n| arr << (block[0].call to_a[n]) }
    else
      size.times { |n| arr << (yield to_a[n]) }
    end
    arr
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
