---@class Gochi
Gochi={}

---@class GameState
---@field run fun(gc: Gochi)

---@class Caller
---@field name string
---@field t integer Time to kill
---@field istop boolean If caller should be forced to top
---@field run fun(c: Caller) Function runs every frame
---@field kill fun() Function that runs right before death

---@type {[string]: Caller}
Gochi.calls={}

Gochi.void=function()end

---@param s Gochi
---@param name string
Gochi.has=function(s,name)
 return s.calls[name]~=nil
end

---@param s Gochi
---@param name string
Gochi.del=function(s,name)
 s.calls[name]=nil
end
---@alias StateGen fun():GameState
---@type fun(stategen:StateGen,t?:integer)
Gochi.trans=function(stategen,t)
 local t=t or 30
 local p=Vectic.new()
 local s=Vectic.new(0,HEI)
 local increment=2*WID/(t)
 local stage=1
 local hasGen=false
 Gochi:add('trans-default',t,
  function ()
   rect(p.x,p.y,s.x,s.y,12)
   if s.x>=WID then
    stage=2
   end
   if stage==1 then
    s.x=s.x+increment
   else
    if not hasGen then
     hasGen=true
     Gochi.current=stategen()
    end
    p.x=p.x+increment
   end
  end,
  Gochi.void)
end

---@param s Gochi
---@param name string
---@param t integer
---@param run fun()
---@param kill? fun()
---@param delay? number
---@param forcetop? boolean
Gochi.add=function(s,name,t,run,kill,delay,forcetop)
 delay=delay or 0
 kill=kill or Gochi.void
 if s:has(name) then return end
 s.calls[name]={
  name=name,
  t=t,
  run=function(c)
   if delay>0 then
    delay=delay-1
    return
   end
   c.t=c.t-1
   if c.t~=0 then run()
   else c.kill() end
  end,
  kill=function()
   kill()
   s:del(name)
  end,
  istop=forcetop
 }
end

---@type GameState
Gochi.current = {run=function(gc)end}

---@param s Gochi
Gochi.run=function(s)
 Gochi.current.run(s)
 local tops={}
 for _,c in pairs(s.calls) do
  if c.istop then
    table.insert(tops,c)
  else
    c:run()
  end
 end
 for _,c in ipairs(tops) do
  c:run()
 end
end

---@param s Gochi
---@param name string
---@param vec any
---@param t integer Shake duration
---@param i number Shake intensity
Gochi.shake=function(s,name,vec,t,i)
 local ox,oy=vec:xy()
 s:add(name..'_shake',t,function()
  vec.x=math.random(ox-i,ox+i)
  vec.y=math.random(oy-i,oy+i)
 end,
 function()
  vec.x=ox
  vec.y=oy
 end)
end
