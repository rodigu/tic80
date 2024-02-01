---@class Garde
---@field pos Vectic
---@field vel Vectic
---@field dir Vectic
---@field sp number
---@field rot_sp number
local Garde={}
Garde,__index = Garde

---@type fun(): Garde
Garde.new=function()
  return {
    pos=Vectic.new(),
    vel=Vectic.new(),
    dir=Vectic.new(),
    sp=0.03,
    rot_sp=math.pi/30
  }
end

---@type fun(s: Garde)
Garde.draw=function(s)
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

---@type fun(s:Garde)
Garde.move=function(s)
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
end