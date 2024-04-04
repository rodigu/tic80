local p={}

p.counter=0

---@class Particle
---@field pos Vectic
---@field vel Vectic

p.remove=function(kind,unique)
 Gochi:del(kind..unique)
end

p.FIRE='particle-fire-'

---@type fun(origin:Vectic,duration:integer,count?:integer,unique?:string)
p.fire=function(origin,duration,count,unique)
 unique=unique or p.counter
 p.counter=p.counter+1
 count=count or 10

 ---@type Particle[]
 local parts={}
 for _=1,count do
  table.insert(parts,{
   pos=origin:copy(),
   vel=origin.rnd(-.3,.3,-.6,-.2),
   r=math.random(5,7)
  })
 end

 Gochi:add(p.FIRE..unique,duration,
 function()
  for _,v in ipairs(parts) do
   local cor=2
   if v.r<3 then cor=3 end
   if v.r<1 then cor=4 end
   circ(v.pos.x,v.pos.y,v.r,cor)
   v.pos=v.pos+v.vel
   if v.pos.x-origin.x>5 then v.pos.x=v.pos.x+math.random()*-2 end
   if v.pos.x-origin.x<-5 then v.pos.x=v.pos.x+math.random()*2 end
   v.r=v.r-.1
   if v.r<=0 then
    v.pos=origin:copy()
    v.r=math.random(3,5)
   end
  end
 end,
 Gochi.void)
end

p.SPARKS='particle-sparks-'

 ---@type fun(origin:Vectic,duration:integer,count?:integer,gravity?:integer,unique?:string)
p.sparks=function(origin,duration,count,gravity,unique)
 unique=unique or p.counter
 p.counter=p.counter+1
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