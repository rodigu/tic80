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

 local function mdrw()
  rectb(130,20,100,80,12)
  print('HIGH SCORES',150,10,12)
  local sumhigh=0
  for i=1,4 do
    print('P'..i,135,20+10*i,psaves[i].border.color)
    CPrint(psaves[i].high,180,20+10*i,1,psaves[i].border.color)
    sumhigh=psaves[i].high+sumhigh
  end

  CPrint('all time total',180,32+10*5,1,12)
  CPrint(total_scoring,180,40+10*5,1,12)
 end

 return Gochi.menu.create({
  Gochi.menu.makeButton('1P',pselect,Gochi.menu.SELECT),
  Gochi.menu.makeButton('SHOP',shopselect,Gochi.menu.PUSH),
  Gochi.menu.makeButton('OPTIONS',optionsselect,Gochi.menu.PUSH)},20,20,false,mdrw)
end