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

function Vectic.__mod(a,b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x%b.x,a.y%b.y)
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
function Vectic.torus_constrain(a,minx,maxx,miny,maxy)
	if a.x < minx then a.x = maxx
	elseif a.x > maxx then a.x = minx end

	if a.y < miny then a.y = maxy
	elseif a.y > maxy then a.y = miny end
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
    sp=0.1,
    boost=8,
    rot_sp=math.pi/30,
    path=LinkedList.new(Vectic.new(x,y)),
    track_path=false
  }
  setmetatable(g, Garde)
  return g
end

function Garde.draw(s, pos)
  if pos==nil then pos=s.pos end

  if s.track_path then
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
    
    line(n.data.x, n.data.y, pos.x, pos.y, 14)
    if len>5 then
      s.path=LinkedList.cut_head(s.path)
    end
  end

  local rad = 3
	circ(pos.x, pos.y, rad, 13)
  local dir = s.dir:normalize()
  local p1 = (dir*9):rotate(.2) + pos
  local p2 = (dir*9):rotate(-.2) + pos
  local p3 = (dir*2):rotate(-math.pi *.7) + pos
  local p4 = (dir*2):rotate(math.pi * .7) + pos

  tri(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,13)
  tri(p1.x,p1.y,p2.x,p2.y,p4.x,p4.y,13)
end

local F=0
function Garde.move(s)
  F=F+1
  if btn(4) then
    s.vel = s.vel + s.dir * s.sp * s.boost
  elseif btn(6) then
    s.vel = s.vel + s.dir * s.sp
  end
  if btn(3) then
    s.dir = s.dir:rotate(s.rot_sp)
  end
  if btn(2) then
    s.dir = s.dir:rotate(-s.rot_sp)
  end
  s.pos = s.pos + s.vel
  if s.track_path and F%(30)==0 then
    LinkedList.append(s.path, LinkedList.new(s.pos))
  end
end


local Starfield = {}

function Starfield.setup(s,count,minsize,maxsize)
 s.stars = {}
 s.minsize = minsize
 s.maxsize = maxsize
 for i=0,count do
  table.insert(s.stars, Vectic.rnd(minsize.x,maxsize.x,minsize.y,maxsize.y))
 end
end

function Starfield.draw(s, move)
 for i,star in ipairs(s.stars) do
  circ(star.x,star.y,1,12)
  if move~=nil then
   local amount = -move
   if i%3==0 then amount = amount / 3
   elseif i%2==0 then amount = amount / 2 end
   star = star + amount
   if star.x < s.minsize.x then
    star.x = s.maxsize.x
    star.y = math.random(s.minsize.y, s.maxsize.y)
   elseif star.x > s.maxsize.x then
    star.x = s.minsize.x
    star.y = math.random(s.minsize.y, s.maxsize.y)
   end
   if star.y < s.minsize.y then
    star.y = s.maxsize.y
    star.x = math.random(s.minsize.x, s.maxsize.x)
   elseif star.y > s.maxsize.y then
    star.y = s.minsize.y
    star.x = math.random(s.minsize.x, s.maxsize.x)
   end
   s.stars[i] = star
  end
 end
end

local g1 = Garde.new(240/2,136/2)
Starfield:setup(200,Vectic.new(-240,-136),Vectic.new(2*240,2*136))

function TIC()
 cls()
 Starfield:draw(g1.vel)
 g1:draw(Starfield.maxsize/4)
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