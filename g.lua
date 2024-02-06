-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

local Vectic={}
Vectic.__index=Vectic

Vectic.new=function(x,y)
  local v = {x = x or 0, y = y or 0}
  setmetatable(v, Vectic)
  return v
end

function Vectic.__add(a,b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x+b.x,a.y+b.y)
end
function Vectic.__sub(a, b)
	a,b=Vectic.twoVec(a,b)
  return Vectic.new(a.x - b.x, a.y - b.y)
end
function Vectic.__mul(a, b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x*b.x,a.y*b.y)
end
function Vectic.__div(a, b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x/b.x,a.y/b.y)
end
function Vectic.__eq(a, b)
	a,b=Vectic.twoVec(a,b)
	return a.x==b.x and a.y==b.y
end
function Vectic.__ne(a, b)
	a,b=Vectic.twoVec(a,b)
	return not Vectic.__eq(a, b)
end
function Vectic.__unm(a)
	return Vectic.new(-a.x, -a.y)
end
function Vectic.__lt(a, b)
	a,b=Vectic.twoVec(a,b)
	 return a.x < b.x and a.y < b.y
end
function Vectic.__le(a, b)
	a,b=Vectic.twoVec(a,b)
	 return a.x <= b.x and a.y <= b.y
end
function Vectic.__tostring(v)
	 return "(" .. v.x .. ", " .. v.y .. ")"
end
function Vectic.twoVec(a,b)
	return Vectic.toVec(a),Vectic.toVec(b)
end
function Vectic.toVec(a)
	if type(a)=='number' then
		return Vectic.new(a,a)
	end
	return a
end
function Vectic.floordiv(a,b)
	b=Vectic.toVec(b)
	return Vectic.new(math.floor(a.x/b.x),math.floor(a.y/b.y))
end
function Vectic.dist2(a,b)
	b=Vectic.toVec(b)
	return(a.x-b.x)^2+(a.y-b.y)^2
end
function Vectic.dist(a,b)
	b=Vectic.toVec(b)
	return math.sqrt(a.dist2(a,b))
end

function Vectic.floor(a)return a.floordiv(a,1)end
function Vectic.norm(a)return a:dist(Vectic.new(0,0))end
function Vectic.normalize(a)return a/a:norm() end
function Vectic.rotate(a,t)return Vectic.new(a.x*math.cos(t)-a.y*math.sin(t),a.x*math.sin(t)+a.y*math.cos(t))end
function Vectic.copy(a)return Vectic.new(a.x,a.y)end
function Vectic.xy(a) return a.x,a.y end
function Vectic.apply(a,f) return Vectic.new(f(a.x),f(a.y)) end
function Vectic.rnd(minx,maxx,miny,maxy)
	return Vectic.new(math.random(minx,maxx),math.random(miny,maxy))
end

local LinkedList = {}

function LinkedList.new(data)
 return {prev=nil, next=nil, data=data}
end

function LinkedList.last(node)
 local n = node
 while n.next ~= nil do
  n = n.next
 end
 return n
end

function LinkedList.first(node)
 local n = node
 while n.prev ~= nil do
  n = n.prev
 end
 return n
end

function LinkedList.append(node, new)
 local last = LinkedList.last(node)
 last.next = new
 new.prev = last
end

function LinkedList.insert(node, new)
 local first = LinkedList.first(node)
 first.prev = new
 new.next = first
end

function LinkedList.cut_tail(node)
 local last = LinkedList.last(node)
 last.prev.next = nil
end

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

local Garde={}
Garde.__index = Garde

function Garde.new(x,y)
  local g = {
    pos=Vectic.new(x,y),
    vel=Vectic.new(.01),
    dir=Vectic.new(1),
    sp=0.03,
    rot_sp=math.pi/30,
    path=LinkedList.new(Vectic.new(x,y))
  }
  setmetatable(g, Garde)
  return g
end



function Garde.draw(s)
  local n = s.path
  local len = 0
  while n.next~=nil do
    len=len+1
    n=n.next
    circ(n.data.x, n.data.y, 2, 14)
    if n.prev ~= nil then
      line(n.prev.data.x, n.prev.data.y, n.data.x, n.data.y, 14)
    end
  end

  line(n.data.x, n.data.y, s.pos.x, s.pos.y, 14)
  if len>5 then
    s.path=LinkedList.cut_head(s.path)
  end

  local rad = 3
	circ(s.pos.x, s.pos.y, rad, 13)
  local dir = s.dir:normalize()
  local p1 = (dir*9):rotate(.2) + s.pos
  local p2 = (dir*9):rotate(-.2) + s.pos
  local p3 = (dir*2):rotate(-math.pi *.7) + s.pos
  local p4 = (dir*2):rotate(math.pi * .7) + s.pos

  tri(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,13)
  tri(p1.x,p1.y,p2.x,p2.y,p4.x,p4.y,13)
end

local F=0
function Garde.move(s)
  F=F+1
  if btn(0) then
    s.vel = s.vel + s.dir * s.sp
  end
  if btn(3) then
    s.dir = s.dir:rotate(s.rot_sp)
  end
  if btn(2) then
    s.dir = s.dir:rotate(-s.rot_sp)
  end
  s.pos = s.pos + s.vel
  if F%(30)==0 then
    LinkedList.append(s.path, LinkedList.new(s.pos))
  end
end

local g1 = Garde.new(240/2,136/2)

function TIC()
 cls()
 g1:draw()
 g1:move()
end
-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>