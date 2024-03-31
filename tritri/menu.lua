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
 return Gochi.menu.create({
  Gochi.menu.makeButton('1P',pselect,Gochi.menu.SELECT),
  Gochi.menu.makeButton('SHOP',Gochi.void,Gochi.menu.PUSH),
  Gochi.menu.makeButton('OPTIONS',Gochi.void,Gochi.menu.PUSH)},20,20)
end