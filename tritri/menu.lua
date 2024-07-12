function menugen()
  local TRANS='transition'
  Somchi.add(2,TRANS,35,11)
 ---@param s MenuButton
 local function pselect(s)
  local pcount=tonumber(s.txt:sub(1,1))
  if btnp(2) then
   s.txt=(math.floor(s.txt:sub(1,1))-1)..'P'
  end
  if btnp(3) then
   s.txt=(math.floor(s.txt:sub(1,1))+1)..'P'
  end
  if btnp(4) then
   Somchi.play(TRANS)
   Gochi.trans(pgen(s.txt))
  end
 end
 
 ---@param s MenuButton
 local function shopselect(s)
  if btnp(4) then
   Gochi.trans(shopgen)
  end
 end

 ---@param s MenuButton
 local function optionsselect(s)
  if btnp(4) then
   Gochi.trans(genoptions)
  end
 end

 ---@type PlayerStore[]
 local psaves={}
 for i=1,4 do
  psaves[i]=Strg.load(i)
 end

 local total_scoring=Strg.loadtotal()

 local blckfallanim=genfallblock(40)

 local ctrl={
  a=276,
  z=277,
  up=278,
  down=279,
  left=280,
  right=281
 }

 local show_controls=function()
  local x=15
  local y=75
  rect(x,y,60,50,0)
  rectb(x,y,60,50,15)
  CPrint('controls',x+31,y+5,1,12)
  local A=ctrl.a
  local Z=ctrl.z
  local up=ctrl.up
  local down=ctrl.down
  local left=ctrl.left
  local right=ctrl.right
  if btn(4) or key(26) then
   A=A+16
   Z=Z+16
  end
  if btn(0) then
   up=up+16
  end
  if btn(1) then
   down=down+16
  end
  if btn(2) then
   left=left+16
  end
  if btn(3) then
   right=right+16
  end
  pal()
  x=x+10
  spr(A,x,y+17,0)
  CPrint('or',x+5,y+29,1,12)
  spr(Z,x,y+38,0)
  x=x+25
  spr(up,x,y+18,0)
  spr(down,x,y+32,0)
  spr(left,x-8,y+25,0)
  spr(right,x+8,y+25,0)
 end

 local function mdrw()
  blckfallanim:run()
  rect(120,5,120,105,0)
  rectb(120,5,120,105,15)
  rectb(130,20,100,80,12)
  rect(15,22,37,32,0)
  rectb(15,22,37,32,15)
  print('HIGH SCORES',150,10,12)
  local sumhigh=0
  for i=1,4 do
    print('P'..i,135,20+10*i,psaves[i].border.color)
    CPrint(psaves[i].high,180,20+10*i,1,psaves[i].border.color)
    sumhigh=psaves[i].high+sumhigh
  end

  CPrint('all time total',180,32+10*5,1,12)
  CPrint(total_scoring,180,40+10*5,1,12)
  show_controls()
 end

 return Gochi.menu.create({
  Gochi.menu.makeButton('1P',pselect,Gochi.menu.SELECT),
  Gochi.menu.makeButton('SHOP',shopselect,Gochi.menu.PUSH),
  Gochi.menu.makeButton('OPTIONS',optionsselect,Gochi.menu.PUSH)},20,20,false,mdrw)
end