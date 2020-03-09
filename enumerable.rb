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
    while i < arr.lenght
      if test_class == Hash
        yield(arr[i], arr[i+1])
        i += 2
      else
        yield(arr[i])
        i += 1
      end
    end
  end
  
  def my_each_with_index
  end
  def my_select
  end
  def my_all?
  end
  def my_any?
  end
  def my_none?
  end
  def my_count
  end
  def my_map
  end
  def my_inject
  end
  def multiply_els
  end
end