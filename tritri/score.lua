---@param players TriPlayer[]
---@return GameState
function scoreScreenGen(players)
 Somchi.add(3,'count-up-bip',40,3)
 local frms=60
 local iscores={}
 local high=0
 ---@type PlayerStore[]
 local highscores={}
 local total_scoring=0
 for i=1,#players do
  total_scoring=total_scoring+players[i].score
  highscores[i]=Strg.load(i).high
  if highscores[i]<players[i].score then
   Strg.save(players[i],players[i].score)
  end
  if high<players[i].score then
   high=players[i].score
  end
  iscores[i]=0
 end
 Strg.savetotal(total_scoring)

 local ptadd=high/frms
 return {
  run=function(gc)
   for i,p in ipairs(players) do
    local x=p.pos.x+4*(p.wid+2)
    local y=HEI-(iscores[i]/(high+1))*HEI*.5
    rect(x-5,y,10,HEI,6)
    y=y-20
    local w=CPrint('P'..i,x,y,1,p.border.color)
    if high==iscores[i] then
     spr(272,x-4,y-12)
     if ((math.floor(time())%1000)<500) and (highscores[i]<players[i].score) then
      CPrint('NEW!', x+1, y-20,1,3)
     end
    else
     if time()%60<30 then
      Somchi.play('count-up-bip')
     end
    end
    if iscores[i]<p.score then
     iscores[i]=iscores[i]+ptadd
    else
     iscores[i]=p.score
    end
    CPrint(math.floor(iscores[i]),x,y+10,1,p.border.color)
   end
   if btnp(4) then
    Gochi.current=menugen()
   end
  end
 }
end