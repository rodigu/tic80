local menu={}

---@class MenuButton
---@field onSelect fun(s:MenuButton)
---@field txt string
---@field type string

---@class Menu
---@field buttons MenuButton[]
---@field choice integer
---@field run fun(s:Menu)

menu.PUSH='push'
menu.SELECT='select'
menu.TOGGLE='toggle'

---@type fun(txt:string,onSelect:fun(s:MenuButton),btype:'push'|'select'|'toggle'):MenuButton
function menu.makeButton(txt,onSelect,btype)
 return {txt=txt,onSelect=onSelect,type=btype}
end

---@type fun(buttons:MenuButton[],x:number,y:number):Menu
function menu.create(buttons,x,y)
 local btndelay=10
 local f=btndelay
 local m={
  buttons=buttons,
  choice=0,
 }
 local bscale=1

 local drw=function()
  for i,b in ipairs(buttons) do
   local color=14
   local btxt=b.txt
   if b.type==Gochi.menu.SELECT then
    btxt='< '..btxt..' >'
   end
   if m.choice+1==i then
    color=12
    local wid=CPrint(btxt,WID,HEI,bscale,color,true)
    line(x,y+i*bscale*8+bscale*8*.8,x+wid-2,y+i*bscale*8+bscale*8*.8,12)
    b:onSelect()
   end
   CPrint(btxt,x,y+i*bscale*8,bscale,color,true)
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

Gochi.menu=menu