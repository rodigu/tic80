---@class MenuButton
---@field onSelect fun()
---@field txt string

---@class Menu
---@field buttons MenuButton[]
---@field choice integer
---@field run fun(s:Menu)

---@type fun(txt:string,onSelect:fun()):MenuButton
function makeMB(txt,onSelect)
 return {txt=txt,onSelect=onSelect}
end

---@type fun(buttons:MenuButton[],x:number,y:number):Menu
function CreateMenu(buttons,x,y)
 local btndelay=10
 local f=btndelay
 local m={
  buttons=buttons,
  choice=0,
 }

 local drw=function()
  for i,b in ipairs(buttons) do
   local color=14
   if m.choice+1==i then
    color=12
    spr(511,x-10,y+i*16+2,0)
   end
   CPrint(b.txt,x,y+i*16,2,color,true)
  end
 end

 local ctrls=function()
  if f<btndelay then
   return
  end
  if btn(0) then
   f=0
   m.choice=(m.choice-1)
  end
  if btn(1) then
   f=0
   m.choice=(m.choice+1)
  end
  m.choice=m.choice%(#m.buttons)
 end
 m.run=function(_)
   f=f+1
   ctrls()
   drw()
 end
 return m
end
