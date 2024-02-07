---@module 'aux.vectic'
---@module "aux.linked_list"

---@class Garde
---@field pos Vectic
---@field vel Vectic
---@field dir Vectic
---@field sp number
---@field rot_sp number
---@field path LinkedList
---@field track_path boolean
---@field boost number
local Garde={}
Garde.__index = Garde

---@type fun(x:number,y:number): Garde
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

---@type fun(s: Garde, pos:Vectic|nil)
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
---@type fun(s:Garde)
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