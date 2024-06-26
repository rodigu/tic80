function genoptions()
---@param s MenuButton
local function reset(s)
 if btnp(4) then
  Strg.setmem(true)
 end
end

 ---@param s MenuButton
 local function back(s)
  if btnp(4) then
   Gochi.trans(menugen)
  end
 end

 local slctr=Gochi.menu.create({
  Gochi.menu.makeButton('RESET',reset,'push'),
  Gochi.menu.makeButton('BACK',back,'push')
 },120,0,true)

 return {
  run=function(gc)
   slctr:run()
  end
 }
end