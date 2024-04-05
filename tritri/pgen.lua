---@type fun(p:string):StateGen
function pgen(p)
 ---@type TriPlayer[]
 local ps={}
 local pcount=tonumber(p:sub(1,1))
 for i=1,pcount do
  local loaded=Strg.load(i)
  ps[i]=CreatePlayer(i, {
    l=loaded.l,
    i=loaded.i
   },
   loaded.border)
  ps[i].pos.x=(i-1)*WID/pcount--+(ps[i].wid+2)*4
  ps[i].pos.y=0
  if pcount==1 then
   ps[1].pos.x=WID/2-(ps[1].wid+2)*4
  end
 end
 ---@type StateGen
 local gf=function ()
  return {run=function (gc)
   local gameover=true
   for i=1,pcount do
    ps[i].run(gc)
    gameover=gameover and ps[i].hasLost()
   end
   if gameover and btnp(4) then
    Gochi.current=scoreScreenGen(ps)
   end
  end}
 end
 return gf
end