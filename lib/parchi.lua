local p={}

p.counter=0

---@class Particle
---@field pos Vectic
---@field vel Vectic

---@type fun(origin:Vectic,duration:integer,count?:integer,gravity?:integer)
p.sparks=function(origin,duration,count,gravity)
 gravity=gravity or 1
 count=count or 10
 ---@type Particle[]
 local parts={}
 for _=1,count do
  table.insert(parts,{
   pos=origin:copy(),
   vel=origin.rnd(-3,3,-3,3)
  })
 end
 Gochi:add('particles-sparks-'..p.counter,duration,
 function()
  for _,v in ipairs(parts) do
   circ(v.pos.x,v.pos.y,math.random(1),math.random(2,4))
   v.pos=v.pos+v.vel
   v.vel.y=v.vel.y+gravity
  end
 end,
 function()end)
 p.counter=p.counter+1
end

Gochi.particles=p