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

---@type fun(buttons:MenuButton[],x:number,y:number,docenter?:boolean, extra_drw?:function):Menu
function menu.create(buttons,x,y,docenter, extra_drw)
 extra_drw=extra_drw or function()end
 local m={
  buttons=buttons,
  choice=0,
 }
 local bscale=1
 local MOVESOUND='menu-move'
 Somchi.add(63,MOVESOUND,40,10)
 Somchi.volume=14

 local drw=function()
  for i,b in ipairs(buttons) do
   local color=14
   local btxt=b.txt
   if b.type==Gochi.menu.SELECT then
    btxt='< '..btxt..' >'
   end
   if m.choice+1==i then
    color=12
    local wid=CPrint(btxt,WID,HEI,bscale,color,not docenter)
    local lx=x
    if docenter then
     lx=lx-wid/2
    end
    line(lx,y+i*bscale*8+bscale*8*.8,lx+wid-2,y+i*bscale*8+bscale*8*.8,12)
    b:onSelect()
   end
   CPrint(btxt,x,y+i*bscale*8,bscale,color,not docenter)
  end
 end

 local ctrls=function()
  if btnp(0) then
   m.choice=(m.choice-1)
   Somchi.play(MOVESOUND,1)
  end
  if btnp(1) then
   m.choice=(m.choice+1)
   Somchi.play(MOVESOUND,1)
  end
  m.choice=m.choice%(#m.buttons)
 end
 m.run=function(_)
   ctrls()
   extra_drw()
   drw()
 end
 return m
end

Gochi.menu=menu