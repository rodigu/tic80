---@param players TriPlayer[]
---@return GameState
function scoreScreenGen(players)
 local frms=60
 local iscores={}
 local high=0
 for i=1,#players do
  if high<players[i].score then
   high=players[i].score
  end
  iscores[i]=0
 end
 return {
  run=function(gc)
   for i,p in ipairs(players) do
    local x=p.pos.x+4*(p.wid+2)
    local y=HEI*.4
    local ptadd=p.score/frms
    local w=CPrint('P'..i,x,y,1,p.border.color)
    if high==iscores[i] then
     spr(272,x-4,y-12)
    end
    if iscores[i]<p.score then
     iscores[i]=iscores[i]+ptadd
    else
     iscores[i]=p.score
    end
    CPrint(math.floor(iscores[i]),x,y+10,1,p.border.color)
   end
   if btn(4) then
    Gochi.current=menugen()
   end
  end
 }
end