module Enumerable
  def my_all?
    my_each do |n|
      return false unless yield(n)
    end

    true
  end

  def my_any?
    each do |n|
      return true if yield(n)
    end

    false
  end

  def my_count(arg = nil)
    return size if arg.nil? && !block_given?

    count = 0
    my_each do |n|
      if arg.nil?
        count += 1 if yield(n)
      elsif n == arg
        count += 1
      end
    end

    count
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    index = 0
    my_each do |item|
      yield(item, index)
      index += 1
    end

    self
  end

  def my_inject(initial_value = nil)
    total = initial_value

    no_initial_value_provided = initial_value.nil?

    my_each do |n|
      if no_initial_value_provided
        total = n
        no_initial_value_provided = false
      else
        total = yield(total, n)
      end
    end

    total
  end

  def my_map
    return to_enum(:my_map) unless block_given?

    new_arr = []
    my_each do |n|
      new_arr << yield(n)
    end

    new_arr
  end

  def my_none?
    none = true
    my_each do |n|
      none = false if yield(n)
    end

    none
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    selected = []
    my_each do |n|
      selected << n if yield(n)
    end

    selected
  end
end

class Array
  def my_each
    return to_enum(:my_each) unless block_given?

    for i in self do
      yield(i)
    end

    self
  end
end
