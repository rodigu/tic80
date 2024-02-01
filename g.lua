-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

---@class Vectic
---@field x number
---@field y number
local Vectic={}
Vectic.__index=Vectic

---@type fun(a?:number,b?:number): Vectic
Vectic.new=function(x,y)
  local v = {x = x or 0, y = y or 0}
  setmetatable(v, Vectic)
  return v
end

---@alias VecticOperation<OUT> fun(a:number|Vectic,b:number|Vectic):OUT
---@type VecticOperation<Vectic>
function Vectic.__add(a,b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x+b.x,a.y+b.y)
end
---@type VecticOperation<Vectic>
function Vectic.__sub(a, b)
	a,b=Vectic.twoVec(a,b)
  return Vectic.new(a.x - b.x, a.y - b.y)
end
---@type VecticOperation<Vectic>
function Vectic.__mul(a, b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x*b.x,a.y*b.y)
end
---@type VecticOperation<Vectic>
function Vectic.__div(a, b)
	a,b=Vectic.twoVec(a,b)
	return Vectic.new(a.x/b.x,a.y/b.y)
end
---@type VecticOperation<boolean>
function Vectic.__eq(a, b)
	a,b=Vectic.twoVec(a,b)
	return a.x==b.x and a.y==b.y
end
---@type VecticOperation<boolean>
function Vectic.__ne(a, b)
	a,b=Vectic.twoVec(a,b)
	return not Vectic.__eq(a, b)
end
---@type fun(a:Vectic):Vectic
function Vectic.__unm(a)
	return Vectic.new(-a.x, -a.y)
end
---@type VecticOperation<boolean>
function Vectic.__lt(a, b)
	a,b=Vectic.twoVec(a,b)
	 return a.x < b.x and a.y < b.y
end
---@type VecticOperation<boolean>
function Vectic.__le(a, b)
	a,b=Vectic.twoVec(a,b)
	 return a.x <= b.x and a.y <= b.y
end
---@type VecticOperation<string>
function Vectic.__tostring(v)
	 return "(" .. v.x .. ", " .. v.y .. ")"
end
---@type fun(a:Vectic|number,b:Vectic|number):Vectic,Vectic
function Vectic.twoVec(a,b)
	return Vectic.toVec(a),Vectic.toVec(b)
end
---@type fun(a:Vectic|number):Vectic
function Vectic.toVec(a)
	if type(a)=='number' then
		return Vectic.new(a,a)
	end
	return a
end
---@type VecticOperation<Vectic>
function Vectic.floordiv(a,b)
	b=Vectic.toVec(b)
	return Vectic.new(math.floor(a.x/b.x),math.floor(a.y/b.y))
end
---@type VecticOperation<number>
function Vectic.dist2(a,b)
	b=Vectic.toVec(b)
	return(a.x-b.x)^2+(a.y-b.y)^2
end
---@type VecticOperation<number>
function Vectic.dist(a,b)
	b=Vectic.toVec(b)
	return math.sqrt(a.dist2(a,b))
end

---@alias VecticFunction<OUT> fun(a:Vectic):OUT
---@type VecticFunction<Vectic>
function Vectic.floor(a)return a.floordiv(a,1)end
---@type VecticFunction<number>
function Vectic.norm(a)return a:dist(Vectic.new(0,0))end
---@type VecticFunction<Vectic>
function Vectic.normalize(a)return a/a:norm() end
---@type fun(a:Vectic,t:number):Vectic
function Vectic.rotate(a,t)return Vectic.new(a.x*math.cos(t)-a.y*math.sin(t),a.x*math.sin(t)+a.y*math.cos(t))end
---@type VecticFunction<Vectic>
function Vectic.copy(a)return Vectic.new(a.x,a.y)end
---@type fun(a:Vectic):number,number
function Vectic.xy(a) return a.x,a.y end
---@type fun(a: Vectic,f:fun(x:number):number):Vectic
function Vectic.apply(a,f) return Vectic.new(f(a.x),f(a.y)) end
---@type fun(minx:number,maxx:number,miny:number,maxy:number):Vectic
function Vectic.rnd(minx,maxx,miny,maxy)
	return Vectic.new(math.random(minx,maxx),math.random(miny,maxy))
end

--@class garde
local garde = {
  pos=Vectic.new(240/2, 136/2),
  vel=Vectic.new(.01),
  dir=Vectic.new(1),
  speed=.01
}

garde.draw = function (s)
  local rad = 3
	circ(s.pos.x, s.pos.y, rad, 13)
  local dir = s.dir:normalize()
  local p1 = (dir*9):rotate(.2) + s.pos
  local p2 = (dir*9):rotate(-.2) + s.pos
  local p3 = (dir*2):rotate(-math.pi *.7) + s.pos
  local p4 = (dir*2):rotate(math.pi * .7) + s.pos

  tri(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,13)
  tri(p1.x,p1.y,p2.x,p2.y,p4.x,p4.y,13)
  garde.pos = garde.pos + garde.vel
end

function TIC()
  cls(0)
  if btn(0) then
    garde.vel = garde.vel + garde.dir * garde.speed
  end
  if btn(3) then
    garde.dir = garde.dir:rotate(math.pi/20)
  end
  if btn(2) then
    garde.dir = garde.dir:rotate(-math.pi/20)
  end
  garde:draw()
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

