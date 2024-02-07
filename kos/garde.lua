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
---@field higgs number
---@field maxhiggs number
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
    track_path=false,
    maxhiggs=1000,
    higgs=1000
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
	circ(pos.x, pos.y, rad, 12)
  local dir = s.dir:normalize()
  local p1 = (dir*9):rotate(.2) + pos
  local p2 = (dir*9):rotate(-.2) + pos
  local p3 = (dir*2):rotate(-math.pi *.7) + pos
  local p4 = (dir*2):rotate(math.pi * .7) + pos

  tri(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,12)
  tri(p1.x,p1.y,p3.x,p3.y,p4.x,p4.y,12)

  s:UI()
end

---@type fun(pos:Vectic,curr:number,max:number,size:Vectic,col:number)
function ProgressBar(pos,curr,max,size,col)
  if col==nil then col=6 end
  rect(pos.x-1,pos.y-1,size.y+2,size.x+2,12)
  rect(pos.x,pos.y,size.y*curr/max,size.x,col)
end

---@type fun(s:Garde)
function Garde.UI(s)
  ProgressBar(Vectic.new(2,2),s.higgs,s.maxhiggs,Vectic.new(5,30),7)
end

local F=0
---@type fun(s:Garde)
function Garde.move(s)
  F=F+1
  if s.higgs < s.maxhiggs then
    s.higgs=s.higgs+2
  end
  if btn(4) and s.higgs > 0 then
    s.vel = s.vel + s.dir * s.sp * s.boost
    s.higgs = s.higgs-10
  elseif btn(6) and s.higgs > 0 then
    s.vel = s.vel + s.dir * s.sp
    s.higgs = s.higgs-3
  elseif btn(4) and btn(6) and s.higgs < 0 then
    circ(240/2,136/2,10,2)
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