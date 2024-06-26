function unlocked_border(total_score)
 return math.floor(total_score / 100000)
end

function unlocked_l(total_score)
 return math.floor(total_score / 10000)
end

function unlocked_i(total_score)
 return math.floor(total_score / 10000)
end

---@type StateGen
function shopgen()
 local loadPlayer=function(i)
  local loaded=Strg.load(i)
  return CreatePlayer(i, {
    l=loaded.l,
    i=loaded.i
   },
   loaded.border)
 end

 local player=loadPlayer(1)

 local function pselect(s)
  local pcount=tonumber(s.txt:sub(1,1))
  if btnp(2) then
   pcount=pcount-1
   Strg.save(player)
   player=loadPlayer(pcount)
  end
  if btnp(3) then
   pcount=pcount+1
   Strg.save(player)
   player=loadPlayer(pcount)
  end
  s.txt=(math.floor(pcount))..'P'
 end

 ---@param s MenuButton
 local function bordercor(s)
  if btnp(2) then
   player.border.color=player.border.color-1
  end
  if btnp(3) then
   player.border.color=player.border.color+1
  end
 end

 ---@param s MenuButton
 local function borderstyle(s)
  if btnp(2) then
   player.border.id=player.border.id-16
  end
  if btnp(3) then
   player.border.id=player.border.id+16
  end
 end

 ---@param s MenuButton
 local function lcor(s)
  if btnp(2) then
   player.block.l.color=player.block.l.color-1
  end
  if btnp(3) then
   player.block.l.color=player.block.l.color+1
  end
 end

 ---@param s MenuButton
 local function lstyle(s)
  if btnp(2) then
   player.block.l.id=player.block.l.id-1
  end
  if btnp(3) then
   player.block.l.id=player.block.l.id+1
  end
 end

 ---@param s MenuButton
 local function icor(s)
  if btnp(2) then
   player.block.i.color=player.block.i.color-1
  end
  if btnp(3) then
   player.block.i.color=player.block.i.color+1
  end
 end

 ---@param s MenuButton
 local function istyle(s)
  if btnp(2) then
   player.block.i.id=player.block.i.id-1
  end
  if btnp(3) then
   player.block.i.id=player.block.i.id+1
  end
 end

 local originals = {
  border=player.border.id,
  l=player.block.l.id,
  i=player.block.i.id
 }

 local total_score=Strg.loadtotal()

 ---@param s MenuButton
 local function back(s)
  if btnp(4) then
   if unlocked_border(total_score) < player.border.id then
    player.border.id=originals.border
   end
   if unlocked_i(total_score) + 256 < player.block.i.id then
    player.block.i.id=originals.i
   end
   if unlocked_l(total_score) + 256 < player.block.l.id then
    player.block.l.id=originals.l
   end
   Gochi.trans(menugen)
   Strg.save(player)
  end
 end


 local slctr=Gochi.menu.create({
  Gochi.menu.makeButton('1P',pselect,'select'),
  Gochi.menu.makeButton('  ',bordercor,'select'),
  Gochi.menu.makeButton('  ',borderstyle,'select'),
  Gochi.menu.makeButton('  ',lcor,'select'),
  Gochi.menu.makeButton('  ',lstyle,'select'),
  Gochi.menu.makeButton('  ',icor,'select'),
  Gochi.menu.makeButton('  ',istyle,'select'),
  Gochi.menu.makeButton('BACK',back,'push')
 },120,0,true)


 local function drw()
  CPrint('total score: '..total_score,WID/2,HEI-30,1,12)
  slctr:run()
  local y=16
  rect(114,y,11,5,player.border.color)
  pal(12,player.border.color)
  y=y+6
  if unlocked_border(total_score) < player.border.id then
   spr(273,116,y,0)
  else
   spr(player.border.id,114,y,0)
  end
  pal()

  y=y+10
  rect(114,y,11,5,player.block.l.color)
  pal(12,player.block.l.color)
  y=y+7
  if unlocked_l(total_score) + 256 < player.block.l.id then
   spr(273,116,y,0)
  else
   spr(player.block.l.id,116,y,0)
  end
  pal()

  y=y+10
  rect(114,y,11,5,player.block.i.color)
  pal(12,player.block.i.color)
  y=y+7
  if unlocked_i(total_score) + 256 < player.block.i.id then
   spr(273,116,y,0)
  else
   spr(player.block.i.id,116,y,0)
  end
  pal()
  -- rectb(114,16,11,5,12)
 end

 return {
  ---@param gc Gochi
  run=function (gc)
   drw()
  end
 }
end
