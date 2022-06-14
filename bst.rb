# frozen_string_literal:true

# Node class
class Node
  attr_accessor :left, :data, :right

  def initialize(value)
    @left = nil
    @data = value
    @right = nil
  end
end

# Tree
class Tree
  def initialize(array)
    @root = binary_search_tree(array.sort.uniq)
  end

  def binary_search_tree(array, cond = false)
    return nil if array.empty?

    mid =  cond ? array[(array.length - 1) / 2] : array[array.length / 2]
    left = array.select { |val| val < mid }
    rigth = array.select { |val| val > mid }
    root = Node.new(mid)
    root.left = binary_search_tree(left)
    root.right = binary_search_tree(rigth, true)
    root
  end

  def insert(value, terminate = false)
    head = @root
    until terminate
      if value > head.data
        if head.right.nil?
          terminate = true
          head.right = Node.new(value)
        else
          head = head.right
        end
      elsif head.left.nil?
        terminate = true
        head.left = Node.new(value)
      else
        head = head.left
      end
    end
  end

  # WARNING, this function may give you cancer so tread carefully
  def delete(value)
    head = @root
    until head.left.nil? && head.right.nil?
      condition1 = (value == head.right.data) unless head.right.nil?
      condition2 = (value == head.left.data) unless head.left.nil?
      if condition1 || condition2 || value == head.data
        if !head.right.nil?
          element = head.right.data == value ? head.right : head.left
        else
          element = head.left.data == value ? head.left : head.right
        end

        if element.left.nil? && element.right.nil?
          return head.left = nil if head.left == element

          return head.right = nil

        elsif element.left.nil? || element.right.nil?
          if head.left == element
            return head.left = element.left.nil? ? element.right : element.left

          else
            return head.right = element.right.nil? ? element.left : element.right

        end

        else
          temp = find(value).right
          temp = temp.left until temp.left.nil?
          data = temp.data
          delete(data)
          if head.data == value
            return head.data = data if head == element
          else
            return head.right == element ? head.right.data = data : head.left.data = data
          end
        end
      end
      if !head.right.nil? && !head.left.nil?
        head = value > head.data ? head.right : head.left
      else
        head = head.right.nil? ? head.left : head.right
      end
    end
  end

  def find(value)
    head = @root
    until head.nil?
      return head if head.data == value

      head = value > head.data ? head.right : head.left
    end
  end

  def level_order(queue = [])
    queue.push(@root)
    arr = []
    until queue.empty?
      sum = []
      queue.each { |node| sum.push(node.data) }
      if block_given?
        queue[0].data = yield(queue[0].data)
      else
        arr.push(queue[0].data)
      end
      queue.push(queue[0].left) unless queue[0].left.nil?
      queue.push(queue[0].right) unless queue[0].right.nil?
      queue.shift
    end
    return arr unless block_given?

    self
  end

  def inorder(root = @root, stack = [])
    if !root.left.nil? then inorder(root.left, stack) end
    if block_given?
      root.data = yield(root.data)
    else
      stack.push(root.data)
    end
    if !root.right.nil? then inorder(root.right, stack) end
    stack
  end

  def preorder(root = @root, stack = [])
    if block_given?
      root.data = yield(root.data)
    else
      stack.push(root.data)
    end
    if !root.left.nil? then preorder(root.left, stack) end
    if !root.right.nil? then preorder(root.right, stack) end
    stack
  end

  def postorder(root = @root, stack = [])
    if !root.left.nil? then postorder(root.left, stack) end
    if !root.right.nil? then postorder(root.right, stack) end
    if block_given?
      root.data = yield(root.data)
    else
      stack.push(root.data)
    end
    stack
  end

  def height(node)
    return 0 if node.nil?

    left = height(node.left)
    right = height(node.right)
    [left, right].max + 1
  end

  def depth(element)
    data = 0
    head = @root
    value = element.data
    until head.nil?
      return data if (head.nil? || head.data == value)

      head = value > head.data ? head.right : head.left
      data += 1
    end
    nil
  end

  def balanced?(root = @root)
    return 1 if root.nil?

    lh = height(root.left)
    rh = height(root.right)

    return true if (((lh - rh).abs <= 1) && balanced?(root.left) && balanced?(root.right))

    false
  end

  def rebalance
    reset = inorder
    @root = binary_search_tree(reset)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

test = Array.new(15) { rand(1..100) }
bst = Tree.new(test)
bst.balanced?
bst.level_order
bst.inorder
bst.preorder
bst.postorder
bst.pretty_print
Array.new(4) { rand(1..100) }.each { |i| bst.insert(i) }
bst.balanced?
bst.pretty_print
bst.rebalance
bst.balanced?
bst.level_order
bst.inorder
bst.preorder
bst.postorder
bst.pretty_print
