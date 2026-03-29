module Enumerable
  def my_all?(patern = nil)
    expr = patern.nil? ? ->(n) { yield n } : ->(n) { patern === n }

    my_each do |n|
      return false unless expr.call(n)
    end

    true
  end

  def my_any?(patern = nil)
    expr = patern.nil? ? -> (elem) {yield elem} : lambda { |elem| patern === elem}

    each do |elem|
      return true if expr.call(elem)
    end
    false
  end

  def my_count(item = nil)
    return length if item.nil? && !block_given?

    count = 0
    expr = block_given? ? ->(elem) { yield elem} : ->(elem) { item == elem }

    my_each { |elem| count += 1 if expr.call(elem) }

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

  def my_inject(*args)
    # patern filtering => variables sym, initial
    case args 
    in [a] if a.is_a? Symbol
      sym = a
    in [a] if a.is_a? Object
      initial = a
    in [a, b] 
      initial = a
      sym = b
    else 
      initial = nil 
      sym = nil 
    end
    # memory initialisation
    memo = initial || first 
    # loop and update memory
    if block_given?
      my_each_with_index do |elem, i|
        next if initial.nil? && i.zero? 
        memo = yield memo, elem 
      end
    elsif sym 
      my_each_with_index do |elem, i|
        next if initial.nil? && i.zero?
        memo =  memo.send(sym, elem)
      end
    end
    #return memory
    memo 
  end

  def my_map(block = nil)
    return to_enum(:my_map) unless block_given?
    new_arr = []
    expr = block_given? ? ->(elem) { yield elem} : ->(elem) { block.call(elem) }
    my_each { |elem| new_arr << expr.call(elem)}
    new_arr
  end

  def my_none?(patern = nil)
    expr = ->(elem) {yield elem} if block_given?
    expr = patern ? ->(elem) { patern === elem } : ->(elem) { false ^ elem} unless block_given?

    my_each { |elem| return false if expr.call(elem) }
    
    true 
  end

  def my_select
    return to_enum(:my_select) unless block_given?
    selected = []
    my_each { |elem| selected.push(elem) if yield elem }
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
