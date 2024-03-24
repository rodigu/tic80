---@class Gochi
Gochi={}

---@class GameState
---@field run fun(gc: Gochi)

---@class Caller
---@field name string
---@field t integer Time to kill
---@field run fun(c: Caller) Function runs every frame
---@field kill fun() Function that runs right before death

---@type {[string]: Caller}
Gochi.calls={}

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

---@param s Gochi
---@param name string
---@param t integer
---@param run fun()
---@param kill fun()
---@param delay? number
Gochi.add=function(s,name,t,run,kill,delay)
 delay=delay or 0
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
  end
 }
end

---@type GameState
Gochi.current = {run=function(gc)end}

---@param s Gochi
Gochi.run=function(s)
 Gochi.current.run(s)
 for _,c in pairs(s.calls) do
  c:run()
 end
end
