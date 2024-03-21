-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
WID=240
HEI=136

function pal(c0,c1)
 if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i)end
 else poke4(0x3FF0*2+c0,c1) end
end

function indexOf(array, value)
 for i, v in ipairs(array) do
  if v == value then return i end
 end
 return nil
end

function CPrint(txt,x,y,scale,color,notcenter)
 local w=print(txt,WID,HEI,color,true,scale,true)
 if notcenter then w=0 end
 print(txt,x-w/2,y,color,true,scale,true)
end

function splitStr (inputstr, sep)
 if sep == nil then
  sep = "%s"
 end
 local t={}
 for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
  table.insert(t, str)
 end
 return t
end
---@class Somchi
Somchi = {}

---@class Som
---@field id integer
---@field note integer
---@field duration number
---@field speed number

---@type table<string,Som>
Somchi.sounds = {}

---@type integer
Somchi.volume=10

---@type fun(id:integer,name:string,note:integer,duration?:number,speed?:number)
Somchi.add=function(id,name,note,duration,speed)
 duration=duration or -1
 speed=speed or 0
 Somchi.sounds[name] = {
  id=id,
  note=note,
  duration=duration,
  speed=speed
 }
end

---@type fun(name:string,channel?:integer,note?:integer,duration?:number,speed?:number)
Somchi.play=function(name,channel,note,duration,speed)
 local som=Somchi.sounds[name]
 duration=duration or som.duration
 speed=speed or som.speed
 note=note or som.note
 channel=channel or 0
 sfx(som.id,note,duration,channel,Somchi.volume,speed)
end
---@meta vectic

---@class Vectic
---@field x number
---@field y number
local Vectic = {}
Vectic.__index = Vectic

---@type fun(a?:number,b?:number): Vectic
Vectic.new = function(x, y)
  local v = { x = x or 0, y = y or 0 }
  setmetatable(v, Vectic)
  return v
end

---@alias VecticOperation<OUT> fun(a:number|Vectic,b:number|Vectic):OUT
---@type VecticOperation<Vectic>
function Vectic.__mod(a, b)
  a, b = Vectic.twoVec(a, b)
  return Vectic.new(a.x % b.x, a.y % b.y)
end

---@type VecticOperation<Vectic>
function Vectic.__add(a, b)
  a, b = Vectic.twoVec(a, b)
  return Vectic.new(a.x + b.x, a.y + b.y)
end

---@type VecticOperation<Vectic>
function Vectic.__sub(a, b)
  a, b = Vectic.twoVec(a, b)
  return Vectic.new(a.x - b.x, a.y - b.y)
end

---@type VecticOperation<Vectic>
function Vectic.__mul(a, b)
  a, b = Vectic.twoVec(a, b)
  return Vectic.new(a.x * b.x, a.y * b.y)
end

---@type VecticOperation<Vectic>
function Vectic.__div(a, b)
  a, b = Vectic.twoVec(a, b)
  return Vectic.new(a.x / b.x, a.y / b.y)
end

---@type VecticOperation<boolean>
function Vectic.__eq(a, b)
  a, b = Vectic.twoVec(a, b)
  return a.x == b.x and a.y == b.y
end

---@type VecticOperation<boolean>
function Vectic.__ne(a, b)
  a, b = Vectic.twoVec(a, b)
  return not Vectic.__eq(a, b)
end

---@type fun(a:Vectic):Vectic
function Vectic.__unm(a)
  return Vectic.new(-a.x, -a.y)
end

---@type VecticOperation<boolean>
function Vectic.__lt(a, b)
  a, b = Vectic.twoVec(a, b)
  return a.x < b.x and a.y < b.y
end

---@type VecticOperation<boolean>
function Vectic.__le(a, b)
  a, b = Vectic.twoVec(a, b)
  return a.x <= b.x and a.y <= b.y
end

---@type VecticOperation<string>
function Vectic.__tostring(v)
  return "(" .. v.x .. ", " .. v.y .. ")"
end

---@type fun(a:Vectic|number,b:Vectic|number):Vectic,Vectic
function Vectic.twoVec(a, b)
  return Vectic.toVec(a), Vectic.toVec(b)
end

---@type fun(a:Vectic|number):Vectic
function Vectic.toVec(a)
  if type(a) == 'number' then
    return Vectic.new(a, a)
  end
  return a
end

---@type VecticOperation<Vectic>
function Vectic.floordiv(a, b)
  b = Vectic.toVec(b)
  return Vectic.new(math.floor(a.x / b.x), math.floor(a.y / b.y))
end

---@type VecticOperation<number>
function Vectic.dist2(a, b)
  b = Vectic.toVec(b)
  return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2
end

---@type VecticOperation<number>
function Vectic.dist(a, b)
  b = Vectic.toVec(b)
  return math.sqrt(a.dist2(a, b))
end

---@alias VecticFunction<OUT> fun(a:Vectic):OUT
---@type VecticFunction<Vectic>
function Vectic.floor(a) return a.floordiv(a, 1) end

---@type VecticFunction<number>
function Vectic.norm(a) return a:dist(Vectic.new(0, 0)) end

---@type VecticFunction<Vectic>
function Vectic.normalize(a) return a / a:norm() end

---@type fun(a:Vectic,t:number):Vectic
function Vectic.rotate(a, t)
  return Vectic.new(a.x * math.cos(t) - a.y * math.sin(t), a.x * math.sin(t) + a.y *
    math.cos(t))
end

---@type VecticFunction<Vectic>
function Vectic.copy(a) return Vectic.new(a.x, a.y) end

---@type fun(a:Vectic):number,number
function Vectic.xy(a) return a.x, a.y end

---@type fun(a: Vectic,f:fun(x:number):number):Vectic
function Vectic.apply(a, f) return Vectic.new(f(a.x), f(a.y)) end

---@type fun(minx:number,maxx:number,miny:number,maxy:number):Vectic
function Vectic.rnd(minx, maxx, miny, maxy)
  return Vectic.new(math.random(minx, maxx), math.random(miny, maxy))
end

---@type fun(a:Vectic,minx:number,maxx:number,miny:number,maxy:number)
function Vectic.torus_constraint(a, minx, maxx, miny, maxy)
  if a.x < minx then
    a.x = maxx
  elseif a.x > maxx then
    a.x = minx
  end

  if a.y < miny then
    a.y = maxy
  elseif a.y > maxy then
    a.y = miny
  end
end

---@type fun(a:Vectic,minx:number,maxx:number,miny:number,maxy:number)
function Vectic.limit_constraint(a, minx, maxx, miny, maxy)
  a.x = math.min(a.x, maxx)
  a.x = math.max(a.x, minx)

  a.y = math.min(a.y, maxy)
  a.y = math.max(a.y, miny)
end
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
---@class Gochi
Gochi={}

---@class GameState
---@field run fun(gc: Gochi)

---@class Caller
---@field name string
---@field t integer Time to kill
---@field run fun(c: Caller) Function runs every frame
---@field kill fun() Function that runs right before death

---@type {[string]: Caller}
Gochi.calls={}

---@param s Gochi
---@param name string
Gochi.has=function(s,name)
 return s.calls[name]~=nil
end

---@param s Gochi
---@param name string
Gochi.del=function(s,name)
 s.calls[name]=nil
end

---@param s Gochi
---@param name string
---@param t integer
---@param run fun()
---@param kill fun()
---@param delay? number
Gochi.add=function(s,name,t,run,kill,delay)
 delay=delay or 0
 if s:has(name) then return end
 s.calls[name]={
  name=name,
  t=t,
  run=function(c)
   if delay>0 then
    delay=delay-1
    return
   end
   c.t=c.t-1
   if c.t~=0 then run()
   else c.kill() end
  end,
  kill=function()
   kill()
   s:del(name)
  end
 }
end

---@type GameState
Gochi.current = {run=function(gc)end}

---@param s Gochi
Gochi.run=function(s)
 for _,c in pairs(s.calls) do
  c:run()
 end
 Gochi.current.run(s)
end
---@class Trimino
Trimino={}

---@class TriPiece
---@field blocks Vectic[]
---@field type 'i'|'l'

---@param piece TriPiece
Trimino._ri=function(piece)
 if piece[2]=='1' then
  return splitStr('0 0 0 i i i 0 0 0')
 else return splitStr('0 i 0 0 i 0 0 i 0')
 end
end

---@param piece TriPiece
---@return Vectic[]
Trimino._rl=function(piece)
 local min,max=Trimino.bounds(piece.blocks)
 local bs=piece.blocks
 ---@param p Vectic
 local function n(b)
  if b==min then return Vectic.new(max.x,min.y) end
  if b.y==min.y then return max end
  if b.x==max.x then return Vectic.new(min.x,max.y) end
  return min
 end

 return {n(bs[1]),n(bs[2]),n(bs[3])}
end

---@param blocks Vectic[]
Trimino.bounds=function(blocks)
 local max=Vectic.new(math.max(blocks[1].x,blocks[2].x,blocks[3].x),math.max(blocks[1].y,blocks[2].y,blocks[3].y))
 local min=Vectic.new(math.min(blocks[1].x,blocks[2].x,blocks[3].x),math.max(blocks[1].y,blocks[2].y,blocks[3].y))
 return min,max
end

---@param piece TriPiece
Trimino.rotate=function(piece)
 local rotvs={}
 if piece.type=='l' then
  rotvs=Trimino._rl(piece)
 else
  rotvs=Trimino._ri(piece)
 end
 piece.blocks=rotvs
end

---@param pos Vectic
Trimino.draw=function(x,y,id,color)
 pal(12,color)
 spr(id,x,y,0)
 pal()
end
---@class Block
---@field color integer
---@field id integer

---@class BlockList
---@field l Block
---@field i Block

---@alias Border Block

---@type fun(id:string,blocks:BlockList,border:Border):TriPlayer
function CreatePlayer(id,blocks,border)
 ---@class TriPlayer
 tp={
  pos=Vectic.new(0,0),
  id=id,
  score=0,
  lines=0,
  block=blocks,
  border=border,
  board={}
 }
 
 local function _createBoard(w,h)
 local b={}
 for x=1,w do
  b[x]={}
  for y=1,h do
   b[x][y]='0'
  end
 end
 return b
end

 tp.wid=7
 tp.hei=12
 tp.board=_createBoard(tp.wid,tp.hei)

 ---@param s TriPlayer
 ---@param x number
 ---@param y number
 ---@param flip? integer
 ---@param iscorner? boolean
 ---@param rotate? integer
 tp.bSection=function(s,x,y,flip,iscorner,rotate)
  flip=flip or 0
  iscorner=iscorner or false
  rotate=rotate or 0
  local id=s.border.id
  if not iscorner then id=id+1 end
  pal(12,s.border.color)
  spr(id,x,y,0,1,flip,rotate)
 end

 ---@param s TriPlayer
 tp.sides=function(s)
  for x=8,(s.wid)*8,8 do
   if x>8 then
    line(x-1,s.pos.y+8,x-1,s.hei*8+7,0)
   end
   s:bSection(x,s.pos.y,0,false)
   s:bSection(x,s.pos.y+(s.hei+1)*8,0,false,0)
  end
  for y=8,(s.hei)*8,8 do
   if y>8 then
    line(s.pos.x+8,y-1,s.wid*8+7,y-1,0)
   end
   s:bSection(s.pos.x,y,0,false,1)
   s:bSection(s.pos.x+(s.wid+1)*8,y,0,false,1)
  end
 end

 ---@param s TriPlayer
 tp.corners=function(s)
  s:bSection(s.pos.x,s.pos.y,0,true)
  s:bSection(s.pos.x+8*(s.wid+1),s.pos.y,1,true)
  s:bSection(s.pos.x+8*(s.wid+1),s.pos.y+8*(s.hei+1),3,true)
  s:bSection(s.pos.x,s.pos.y+8*(s.hei+1),2,true)
 end

 ---@param s TriPlayer
 tp.drawBorder=function(s)
  rect(s.pos.x+8,s.pos.y+8,s.wid*8,s.hei*8,15)
  pal(12,s.border.color)
  s:corners()
  s:sides()
  pal()
 end

 ---@param s TriPlayer
 tp.drawInfo=function(s)
  local x,y=s.pos.x+(s.wid+2.5)*4,(s.hei+2)*8
  CPrint(s.id,x,y,1,12)
  CPrint('SCORE: '..s.score,x,y+7,1,12)
  CPrint('LINES: '..s.lines,x,y+14,1,12)
 end

 ---@param s TriPlayer
 tp.drawBoard=function(s)
  for x,t in ipairs(s.board) do
   for y,c in ipairs(t) do
    if c=='i' then
     Trimino.draw(x*8,y*8,s.block.i.id,s.block.i.color)
    elseif c=='l' then
     Trimino.draw(x*8,y*8,s.block.l.id,s.block.l.color)
    end
   end
  end
 end

 ---@param pos Vectic
 tp.outBounds=function(pos)
  local x,y=false,false
  if tp.board[x]==nil then x=true end
  if tp.board[1][y]==nil then y=true end
  return x,y
 end

 ---@param s Gochi
 tp.run=function(s)
  tp:drawBorder()
  tp:drawInfo()
  tp:drawBoard()
 end
 return tp
end
p1=CreatePlayer('PLAYER 1', {
 l={color=3,id=256},
 i={color=2,id=256}
},{
 color=9,
 id=0
})

p1.board[2][2]='l'

m=CreateMenu({makeMB('1 PLAYER'),makeMB('2 PLAYERS'),makeMB('SHOP'),makeMB('OPTIONS')},20,20)
Gochi.current=p1

function TIC()
 cls(0)
 Gochi:run()
end
-- <TILES>
-- 000:0000000000000000000ccccc00c000cc00c0c0cc00c000cc00cccc0000cccc00
-- 001:0000000000000000cccccccccccccccccccccccccccccccc0000000000000000
-- 016:0000000000ccccc00cc000cc0c0c00c00c00c0c00c000ccc0ccccc0000c00c00
-- 017:0000000000000000ccccccccc00c00c00c00c00ccccccccc0000000000000000
-- 032:000000000cccccc00cc00ccc0c0000c00c0000c00cc00ccc0cccccc000c00c00
-- 033:0000000000000000cccccccccc0000cc000cc000cccccccc0000000000000000
-- 048:00cccc000c0000ccc000000cc00cccc0c00cccc0c00cc00c0c0cc0cc0cc00cc0
-- 049:00000000cccccccc00000000cccccccccccccccc00000000cccccccc00000000
-- 064:0000000000cccc000cccccc00ccccccc0ccccccc0cccccc000cccc00000cc000
-- 065:000000000000000000000000cccccccccccccccc000000000000000000000000
-- 080:0000000000000000000cc00c00c00cc000c00cc0000cc00c000cc00000c00c00
-- 081:0000000000000000c00cc00c0cc00cc00cc00cc0c00cc00c0000000000000000
-- </TILES>

-- <SPRITES>
-- 000:ccccccc0c00000c0c0ccc0c0c0ccc0c0c0ccc0c0c00000c0ccccccc000000000
-- 001:0ccccc00c00000c0c00c00c0c0ccc0c0c00c00c0c00000c00ccccc0000000000
-- 002:c00000c00ccccc000ccccc000cc0cc000ccccc000ccccc00c00000c000000000
-- 003:00ccc0000c000c00c00000c0c00000c0c00000c00c000c0000ccc00000000000
-- 004:00ccc0000c000c00c0ccc0c0c0ccc0c0c0ccc0c00c000c0000ccc00000000000
-- 255:cc0000000ccc000000cccc00000ccccc000ccccc00cccc000ccc0000cc000000
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>