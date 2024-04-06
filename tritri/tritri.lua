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
 return print(txt,x-w/2,y,color,true,scale,true)
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

---@type fun(pos:Vectic,curr:number,max:number,size:Vectic,col:number,bck_col?:number)
function ProgressBar(pos,curr,max,size,col,bck_col)
  if bck_col==nil then bck_col=12 end
  if col==nil then col=6 end
  rect(pos.x-1,pos.y-1,size.x+2,size.y+2,bck_col)
  rect(pos.x,pos.y,size.x*curr/max,size.y,col)
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
  return Vectic.new(math.random()*(maxx-minx)+minx, math.random()*(maxy-miny)+miny)
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
---@class Gochi
Gochi={}

---@class GameState
---@field run fun(gc: Gochi)

---@class Caller
---@field name string
---@field t integer Time to kill
---@field istop boolean If caller should be forced to top
---@field run fun(c: Caller) Function runs every frame
---@field kill fun() Function that runs right before death

---@type {[string]: Caller}
Gochi.calls={}

Gochi.void=function()end

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
---@alias StateGen fun():GameState
---@type fun(stategen:StateGen,t?:integer)
Gochi.trans=function(stategen,t)
 local t=t or 30
 local p=Vectic.new()
 local s=Vectic.new(0,HEI)
 local increment=2*WID/(t)
 local stage=1
 local hasGen=false
 Gochi:add('trans-default',t,
  function ()
   rect(p.x,p.y,s.x,s.y,12)
   if s.x>=WID then
    stage=2
   end
   if stage==1 then
    s.x=s.x+increment
   else
    if not hasGen then
     hasGen=true
     Gochi.current=stategen()
    end
    p.x=p.x+increment
   end
  end,
  Gochi.void)
end

---@param s Gochi
---@param name string
---@param t integer
---@param run fun()
---@param kill? fun()
---@param delay? number
---@param forcetop? boolean
Gochi.add=function(s,name,t,run,kill,delay,forcetop)
 delay=delay or 0
 kill=kill or Gochi.void
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
  end,
  istop=forcetop
 }
end

---@type GameState
Gochi.current = {run=function(gc)end}

---@param s Gochi
Gochi.run=function(s)
 Gochi.current.run(s)
 local tops={}
 for _,c in pairs(s.calls) do
  if c.istop then
    table.insert(tops,c)
  else
    c:run()
  end
 end
 for _,c in ipairs(tops) do
  c:run()
 end
end

---@param s Gochi
---@param name string
---@param vec any
---@param t integer Shake duration
---@param i number Shake intensity
Gochi.shake=function(s,name,vec,t,i)
 local ox,oy=vec:xy()
 s:add(name..'_shake',t,function()
  vec.x=math.random(ox-i,ox+i)
  vec.y=math.random(oy-i,oy+i)
 end,
 function()
  vec.x=ox
  vec.y=oy
 end)
end
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

---@type fun(buttons:MenuButton[],x:number,y:number,docenter?:boolean):Menu
function menu.create(buttons,x,y,docenter)
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
   drw()
 end
 return m
end

Gochi.menu=menu
local p={}

p.counter=0

---@class Particle
---@field pos Vectic
---@field vel Vectic

p.remove=function(kind,unique)
 Gochi:del(kind..unique)
end

p.FIRE='particle-fire-'

---@type fun(origin:Vectic,duration:integer,count?:integer,unique?:string)
p.fire=function(origin,duration,count,unique)
 unique=unique or p.counter
 p.counter=p.counter+1
 count=count or 10

 ---@type Particle[]
 local parts={}
 for _=1,count do
  table.insert(parts,{
   pos=origin:copy(),
   vel=origin.rnd(-.3,.3,-.6,-.2),
   r=math.random(5,7)
  })
 end

 Gochi:add(p.FIRE..unique,duration,
 function()
  for _,v in ipairs(parts) do
   local cor=2
   if v.r<3 then cor=3 end
   if v.r<1 then cor=4 end
   circ(v.pos.x,v.pos.y,v.r,cor)
   v.pos=v.pos+v.vel
   if v.pos.x-origin.x>5 then v.pos.x=v.pos.x+math.random()*-2 end
   if v.pos.x-origin.x<-5 then v.pos.x=v.pos.x+math.random()*2 end
   v.r=v.r-.1
   if v.r<=0 then
    v.pos=origin:copy()
    v.r=math.random(3,5)
   end
  end
 end,
 Gochi.void)
end

p.SPARKS='particle-sparks-'

 ---@type fun(origin:Vectic,duration:integer,count?:integer,gravity?:integer,unique?:string)
p.sparks=function(origin,duration,count,gravity,unique)
 unique=unique or p.counter
 p.counter=p.counter+1
 gravity=gravity or 1
 count=count or 10
 ---@type Particle[]
 local parts={}
 for _=1,count do
  table.insert(parts,{
   pos=origin:copy(),
   vel=origin.rnd(-2,2,-4,-1)
  })
 end
 Gochi:add(p.SPARKS..unique,duration,
 function()
  for _,v in ipairs(parts) do
   circ(v.pos.x,v.pos.y,math.random(1),math.random(2,4))
   v.pos=v.pos+v.vel
   v.vel.y=v.vel.y+gravity
  end
 end,
 Gochi.void)
end

Gochi.particles=p
Strg={}

---@class PlayerStore
---@field high integer
---@field l Block
---@field i Block
---@field border Block

Strg.setmem=function()
 for i=1,4 do
  if not Strg.has(i) then
   Strg.save(CreatePlayer(i,{l={color=6,id=256},i={color=2,id=256}},{color=13,id=0}),0)
  end
 end
end

Strg.has=function (p)
 local ploc=(p-1)*(8)
 return pmem(ploc+7)==1
end

---@param tp TriPlayer
Strg.save=function (tp,high)
 if high==nil then
  high=Strg.load(tp.id).high
 end
 local ploc=(tp.id-1)*(8)
 pmem(ploc,high)
 pmem(ploc+1,tp.block.l.id)
 pmem(ploc+2,tp.block.l.color)
 pmem(ploc+3,tp.block.i.id)
 pmem(ploc+4,tp.block.i.color)
 pmem(ploc+5,tp.border.id)
 pmem(ploc+6,tp.border.color)
 pmem(ploc+7,1)
end

---@param p integer
---@return PlayerStore
Strg.load=function(p)
 local ploc=(p-1)*(8)
 local s={
  high=pmem(ploc),
  l={id=pmem(ploc+1),color=pmem(ploc+2)},
  i={id=pmem(ploc+3),color=pmem(ploc+4)},
  border={id=pmem(ploc+5),color=pmem(ploc+6)}}
 return s
end

Strg.borderScore=function(item)
 return (2^item)*10
end

Strg.blockScore=function(item)
 return (3^item)*10
end

Strg.hasBorder=function(score,item)
 return score>=Strg.borderScore(item)
end

Strg.hasBlock=function(score,item)
 return score>=Strg.blockScore(item)
end
---@class Trimino
Trimino={}

---@class TriPiece
---@field blocks Vectic[]
---@field type 'i'|'l'

---@return TriPiece
Trimino.create=function()
 local piecest={'i','l'}
 local t=piecest[math.random(2)]
 
 if t=='l' then
  return {
   blocks={Vectic.new(4,1),Vectic.new(5,1),Vectic.new(4,2)},
   type='l'
  }
 end
 return {
  blocks={Vectic.new(4,2),Vectic.new(5,2),Vectic.new(3,2)},
  type='i'
 }
end

---@type fun(bs:Vectic[]):Vectic[]
Trimino.bottom=function(bs)
 local r={}
 local _,max=Trimino.bounds(bs)

 for _,b in ipairs(bs) do
  if b.y==max.y then table.insert(r,b) end
 end

 return r
end

---@param piece TriPiece
Trimino._ri=function(piece)
 local min,max=Trimino.bounds(piece.blocks)
 ---@param vs Vectic[]
 local function mid(vs)
  for _,v in ipairs(vs) do
   --prone to error if lua is doing mem compare
   if v~=min and v~=max then return v end
  end
 end
 local m=mid(piece.blocks)
 if min.x==max.x then
  return {m,Vectic.new(m.x-1,m.y),Vectic.new(m.x+1,m.y)}
 else
  return {m,Vectic.new(m.x,m.y-1),Vectic.new(m.x,m.y+1)}
 end
end

---@param piece TriPiece
---@param ax 'x'|'y'
---@param mod integer
Trimino.move=function(piece,ax,mod)
 for _,b in ipairs(piece.blocks) do
  b[ax]=b[ax]+mod
 end
end

---@param piece TriPiece
---@return Vectic[]
Trimino._rl=function(piece)
 local min,max=Trimino.bounds(piece.blocks)
 local bs=piece.blocks
 ---@param b Vectic
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
 local min=Vectic.new(math.min(blocks[1].x,blocks[2].x,blocks[3].x),math.min(blocks[1].y,blocks[2].y,blocks[3].y))
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

 ---@param s MenuButton
 local function back(s)
  if btnp(4) then
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
  slctr:run()
  local y=16
  rect(114,y,11,5,player.border.color)
  pal(12,player.border.color)
  y=y+6
  spr(player.border.id,114,y,0)
  pal()

  y=y+10
  rect(114,y,11,5,player.block.l.color)
  pal(12,player.block.l.color)
  y=y+7
  spr(player.block.l.id,116,y,0)
  pal()

  y=y+10
  rect(114,y,11,5,player.block.i.color)
  pal(12,player.block.i.color)
  y=y+7
  spr(player.block.i.id,116,y,0)
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
---@class Block
---@field color integer
---@field id integer

---@class BlockList
---@field l Block
---@field i Block

---@alias Border Block

---@type fun(id:integer,blocks:BlockList,border:Border):TriPlayer
function CreatePlayer(id,blocks,border)
 ---@class TriPlayer
 local tp={
  pos=Vectic.new(0,0),
  id=id,
  score=0,
  lines=0,
  block=blocks,
  border=border,
  board={},
  speed=60
 }

 local comborefresh=false
 local bpdelay=10
 local downdelay=5
 local downcount=0
 local bpcount=0
 local canslam=true
 local CLEAR='clear-lines-sfx'
 local BlAME='slam-block-sfx'
 local combo={
  timer=0,
  timeto=60*10,
  count=1
 }

 local function comboTimeTo()
  local timeto=combo.timeto-(combo.count-1)*30
  if timeto<60 then timeto=60 end
  return timeto
 end

 local function updateCombo()
  if combo.timer<=0 and combo.count>1 then
   combo.count=combo.count-1
   combo.timer=comboTimeTo()
  else
   combo.timer=combo.timer-1
  end
 end
 Somchi.add(0,CLEAR,25,30)
 Somchi.add(0,BlAME,5,10)

 ---@type integer speed frame counter
 local spcount=0

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
 tp.hei=13
 tp.board=_createBoard(tp.wid,tp.hei)
 ---@type TriPiece
 tp.tri=Trimino.create()

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
    line(s.pos.x+x-1,s.pos.y+8,s.pos.x+x-1,s.hei*8+7,0)
   end
   s:bSection(s.pos.x+x,s.pos.y,0,false)
   s:bSection(s.pos.x+x,s.pos.y+(s.hei+1)*8,0,false,0)
  end
  for y=8,(s.hei)*8,8 do
   if y>8 then
    line(s.pos.x+8,s.pos.y+y-1,s.pos.x+s.wid*8+7,s.pos.y+y-1,0)
   end
   s:bSection(s.pos.x,s.pos.y+y,0,false,1)
   s:bSection(s.pos.x+(s.wid+1)*8,s.pos.y+y,0,false,1)
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
  --+(s.wid+2.5)*4
  local x,y=s.pos.x+2,(s.hei+2)*8
  CPrint('PLAYER '..s.id,x,y,1,tp.border.color,true)
  CPrint('SCORE: '..s.score,x,y+7,1,tp.border.color,true)
  -- CPrint('LINES: '..s.lines,x,y+14,1,tp.border.color,true)
  -- ProgressBar(Vectic.new(x+47,y),combo.timer,comboTimeTo(),Vectic.new(20,5),tp.border.color,15)
  -- CPrint(combo.timer,x+8*s.wid,y,1,tp.border.color,true)
  if comborefresh then
   comborefresh=false
   Gochi:del(s.id..'-combo-count')
   Gochi.particles.remove(Gochi.particles.FIRE,s.id..'-combo')
  end
  if combo.count>1 then
   x=x-1
   Gochi.particles.fire(Vectic.new(x+8*s.wid+1,y+7),-1,5*combo.count,s.id..'-combo')
   Gochi:add(s.id..'-combo-count',-1,function ()
    circ(x+8*s.wid+1,y+7+1,4,2)
    -- circb(x+8*s.wid+1,y+7+1,6,12)
    CPrint(combo.count,x+8*s.wid,y+6,1,12,true)
   end,Gochi.void,0,true)
  else
   Gochi.particles.remove(Gochi.particles.FIRE,s.id..'-combo')
   Gochi:del(s.id..'-combo-count')
  end
 end

 ---@param s TriPlayer
 tp.drawBoard=function(s)
  for _,p in ipairs(s.tri.blocks) do
   Trimino.draw(s.pos.x+p.x*8,s.pos.y+p.y*8,s.block[s.tri.type].id,s.block[s.tri.type].color)
  end

  for x,t in ipairs(s.board) do
   for y,c in ipairs(t) do
    if c=='i' then
     Trimino.draw(s.pos.x+x*8,s.pos.y+y*8,s.block.i.id,s.border.color)
    elseif c=='l' then
     Trimino.draw(s.pos.x+x*8,s.pos.y+y*8,s.block.l.id,s.border.color)
    end
   end
  end
 end

 ---@param pos Vectic
 local function isPosOut(pos)
  local x,y=false,false
  if tp.board[pos.x]==nil then x=true end
  if tp.board[1][pos.y]==nil then y=true end
  return x,y
 end

 ---@param blocks Vectic[]
 local function isBlockOut(blocks)
  for _,v in ipairs(blocks) do
   local x,y=isPosOut(v)
   if x or y then return true end
  end
  return false
 end

 ---@param blocks Vectic[]
 local function isLegal(blocks)
  for _,v in ipairs(blocks) do
   if tp.board[v.x]~=nil and tp.board[v.x][v.y]~='0' then
    return false
   end
  end
  return true
 end

 local function pCtrl()
  local cmod=(tp.id-1)*8
  local ismovingdown=false
  if btnp(cmod+4) then
   Trimino.rotate(tp.tri)
  end
  if not btn(cmod) then
   canslam=true
  end
  if canslam and btn(cmod) then
   Trimino.move(tp.tri,'y',1)
   ismovingdown=true
  end
  if downdelay<downcount then
   if btn(cmod+1) then
    downcount=0
    Trimino.move(tp.tri,'y',1)
    ismovingdown=true
   end
  end
  if bpcount<bpdelay then return end
  if btn(cmod+2) then
   bpcount=0
   Trimino.move(tp.tri,'x',-1)
  end
  if btn(cmod+3) then
   bpcount=0
   Trimino.move(tp.tri,'x',1)
  end
  return ismovingdown
 end

 ---@param b Vectic[]
 local function clone(b)
  local r={}
  for i,v in ipairs(b) do
   r[i]=v:copy()
  end
  return r
 end

 ---@param p Vectic[]
 local function canGoDown(p)
  for _,b in ipairs(p) do
   if tp.board[b.x]~=nil and (tp.board[b.x][b.y+1]=='l' or tp.board[b.x][b.y+1]=='i') then
    return false
   end
  end
  return true
 end

 ---@param p Vectic[]
 ---@return boolean
 local function atBottom(p)
  local bBlocks=(tp.tri.blocks)
  if bBlocks[1].y>=tp.hei or not canGoDown(p) then
   return true
  end
  return false
 end
 
 local function lock()
  for _,b in ipairs(tp.tri.blocks) do
   tp.board[b.x][b.y]=tp.tri.type
  end
 end

 local function lineFull(y)
  for x=1,tp.wid do
   if tp.board[x][y]=='0' then return false end
  end
  return true
 end

 local function clearLine(y)
  for x=1,tp.wid do
   tp.board[x][y]='0'
  end
 end

 local function fallBlock(x,y)
  if tp.board[x][y]=='0' or tp.board[x][y]==nil then
   return
  end
  local ch=tp.board[x][y]
  tp.board[x][y]='0'
  while tp.board[x][y+1]~='l' and tp.board[x][y+1]~='i' and tp.board[x][y+1]~=nil do
   y=y+1
  end
  tp.board[x][y]=ch
 end

 local function fallBlocks()
  for x=1,tp.wid do
   for y=tp.hei,1,-1 do
    fallBlock(x,y)
   end
  end
 end

 ---@param lines integer
 local function calcScore(lines)
  return lines*combo.count*10
 end

 ---@param lines integer
 local function addScore(lines)
  tp.lines=tp.lines+lines
  tp.score=tp.score+calcScore(lines)
 end

 local function scanLines()
  local cleared={}
  for y=1,tp.hei do
   if lineFull(y) then
    table.insert(cleared,y)
   end
  end
  if #cleared>0 then
   local oc=tp.border.color
   local fs=4
   local playsfx=true
   Gochi:add('line_clear',30,
   function()
    if playsfx then
     Somchi.play(CLEAR,0,30+2*#cleared)
     playsfx=false
     combo.count=combo.count+math.ceil(#cleared*2)
     comborefresh=true
     combo.timer=comboTimeTo()
    end
    CPrint(#cleared,tp.pos.x+(tp.wid+2)*4+1,tp.pos.y+21,2,0)
    CPrint(#cleared,tp.pos.x+(tp.wid+2)*4,tp.pos.y+20,2,2)
    if fs%10==0 then
     if tp.border.color==oc then
      tp.border.color=oc-1
     else
      tp.border.color=oc
     end
    end
    fs=fs+1
   end,
   function()
    tp.border.color=oc
    for _,y in ipairs(cleared) do
     clearLine(y)
     fallBlocks()
     addScore(#cleared)
    end
    local isclean=true
    for _,ytbl in ipairs(tp.board) do
     if not isclean then
      break
     end
     for _,y in ipairs(ytbl) do
      if y~='0' then
       isclean=false
       break
      end
     end
    end
    if isclean then
     Gochi:add('full-clear',120,
      function ()
       CPrint('FULL CLEAR',tp.pos.x+4*(tp.wid+2)+1,50+1,2,15)
       CPrint('FULL CLEAR',tp.pos.x+4*(tp.wid+2),50,2,12)
       CPrint('+'..calcScore(tp.hei),tp.pos.x+4*(tp.wid+2)+1,70+1,2,15)
       CPrint('+'..calcScore(tp.hei),tp.pos.x+4*(tp.wid+2),70,2,12)
       if not isclean then
        return
       end
       isclean=false
       addScore(tp.hei)
      end)
    end
   end)
  end
 end

 local blockFallSpeed=function()
  return tp.speed-tp.lines/5
 end

 ---@param s TriPlayer
 tp.moveTri=function(s)
  local prev=clone(tp.tri.blocks)

  scanLines()

  if not pCtrl() and spcount>blockFallSpeed() then
   spcount=0
   Trimino.move(tp.tri,'y',1)
  end

  if isBlockOut(tp.tri.blocks) or not isLegal(tp.tri.blocks) then
   if atBottom(prev) then
    tp.tri.blocks=prev
    local min,max=Trimino.bounds(prev)
    lock()
    Somchi.play(BlAME,2)
    Gochi:shake(tp.id,tp.pos,10,1)
    Gochi.particles.sparks(
     Vectic.new(s.pos.x+8*min.x+(8*max.x-8*min.x)/2,s.pos.y+8*max.y),
     20,
     10,
     .5
    )
    tp.tri=Trimino.create()
    spcount=0
    bpcount=0
    downcount=0
    canslam=false
   else
    tp.tri.blocks=prev
   end
  end
 end

 ---@return boolean
 tp.hasLost=function()
  ---@type Vectic[]
  local strt={Vectic.new(4,1),Vectic.new(5,1),Vectic.new(4,2),Vectic.new(5,2),Vectic.new(3,2)}
  for _,v in ipairs(strt) do
   if tp.board[v.x][v.y]~='0' then
    return true
   end
  end
  return false
 end

 ---@param s Gochi
 tp.run=function(s)
  spcount=spcount+1
  bpcount=bpcount+1
  downcount=downcount+1
  tp:drawBorder()
  tp:drawInfo()
  tp:drawBoard()
  updateCombo()
  if not tp.hasLost() then
   tp:moveTri()
  else
   if spcount%60<30 then
    Gochi:del(tp.id..'-combo-count')
    Gochi.particles.remove(Gochi.particles.FIRE,tp.id..'-combo')
    CPrint('GAME OVER',tp.pos.x+tp.wid*4+8,tp.pos.y+tp.hei*4+8,1,2)
   end
  end
 end
 return tp
end
---@type fun(p:string):StateGen
function pgen(p)
 ---@type TriPlayer[]
 local ps={}
 local pcount=tonumber(p:sub(1,1))
 for i=1,pcount do
  local loaded=Strg.load(i)
  ps[i]=CreatePlayer(i, {
    l=loaded.l,
    i=loaded.i
   },
   loaded.border)
  ps[i].pos.x=(i-1)*WID/pcount--+(ps[i].wid+2)*4
  ps[i].pos.y=0
  if pcount==1 then
   ps[1].pos.x=WID/2-(ps[1].wid+2)*4
  end
 end
 ---@type StateGen
 local gf=function ()
  return {run=function (gc)
   local gameover=true
   for i=1,pcount do
    ps[i].run(gc)
    gameover=gameover and ps[i].hasLost()
   end
   if gameover and btnp(4) then
    Gochi.current=scoreScreenGen(ps)
   end
  end}
 end
 return gf
end
---@param players TriPlayer[]
---@return GameState
function scoreScreenGen(players)
 Somchi.add(3,'count-up-bip',40,3)
 local frms=60
 local iscores={}
 local high=0
 ---@type PlayerStore[]
 local highscores={}
 for i=1,#players do
  highscores[i]=Strg.load(i).high
  if highscores[i]<players[i].score then
   Strg.save(players[i],players[i].score)
  end
  if high<players[i].score then
   high=players[i].score
  end
  iscores[i]=0
 end

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

 return Gochi.menu.create({
  Gochi.menu.makeButton('1P',pselect,Gochi.menu.SELECT),
  Gochi.menu.makeButton('SHOP',shopselect,Gochi.menu.PUSH),
  Gochi.menu.makeButton('OPTIONS',Gochi.void,Gochi.menu.PUSH)},20,20)
end
Strg.setmem()

Gochi.current=menugen()

VERSION='v0.1-alpha'

function TIC()
 cls(0)
 Gochi:run()
 print(VERSION,0,HEI-5,15,true,1,true)
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
-- 016:000000000c0c0c00c4c4c4c0c44444c0c44444c0c44444c0ccccccc000000000
-- 255:cc0000000ccc000000cccc00000ccccc000ccccc00cccc000ccc0000cc000000
-- </SPRITES>

-- <WAVES>
-- 000:0000113456789abcd00000446789bcdd
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:ddd0b26bfff92075cef6c6205536cff3
-- </WAVES>

-- <SFX>
-- 000:201620242021203f204e2049205920592059206a206a207b207c208c208c208d209c209c20ad20ae20bf20c020c120c220c320d420d420d520d620e7300000000000
-- 001:20702070207030703060405050305020f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000100000000000
-- 002:00200020006000600080008000b000b000d000d000f000f0f0d0f0d0f0d0f0d0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0370000000000
-- 003:00e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000307000000300
-- 004:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- 062:83359353b38bc3aa93c273b6a375c330b34ba3a993e9b3e4b3a7a3279315b33bb36a93849367a3057313836fa39b8329b345d3a7d372d33ec34cb36c0000000f0f0f
-- 063:00f000d000c000900070005000400010101020104010501060106010f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000400000000000
-- </SFX>

-- <PATTERNS>
-- 001:100040100040100040100040100040f00042800044a00044b00044800044000000000000100040f00042800044a00044b00044800044000000000000100040f00042800044a00044800044000040a00044800044600044000000a00044800044a00044100040a00044100040900044100040a00046b00046800046100040800046100040000000400048f00046e00046400048f00046000000100040000000000000a00046800046700046000040a00046000040700046800046400046000000
-- </PATTERNS>

-- <TRACKS>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

