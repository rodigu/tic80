---@class LinkedNode
---@field data any
---@field prev LinkedNode|nil
---@field next LinkedNode|nil

---@class LinkedList
local LinkedList = {}

---@return LinkedNode
function LinkedList.new(data)
 return {prev=nil, next=nil, data=data}
end

---@param node LinkedNode
function LinkedList.last(node)
 local n = node
 while n.next ~= nil do
  n = n.next
 end
 return n
end

---@param node LinkedNode
function LinkedList.first(node)
 local n = node
 while n.prev ~= nil do
  n = n.prev
 end
 return n
end

---@param node LinkedNode
---@param new LinkedNode
function LinkedList.append(node, new)
 local last = LinkedList.last(node)
 last.next = new
 new.prev = last
end

---@param node LinkedNode
---@param new LinkedNode
function LinkedList.insert(node, new)
 local first = LinkedList.first(node)
 first.prev = new
 new.next = first
end

---@param node LinkedNode
function LinkedList.cut_tail(node)
 local last = LinkedList.last(node)
 last.prev.next = nil
end

---@param node LinkedNode
function LinkedList.cut_head(node)
 local first = LinkedList.first(node)
 first.next.prev = nil
 return first.next
end

local l = LinkedList.new('a')
LinkedList.append(l, LinkedList.new('b'))
LinkedList.append(l, LinkedList.new('c'))
LinkedList.append(l, LinkedList.new('d'))
LinkedList.append(l, LinkedList.new('e'))

local n=l
while n.next~= nil do
 print(n.data)
 n = n.next
end