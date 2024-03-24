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
 tp={
  pos=Vectic.new(0,0),
  id=id,
  score=0,
  lines=0,
  block=blocks,
  border=border,
  board={},
  speed=60
 }

 local bpdelay=10
 local downdelay=5
 local downcount=0
 local bpcount=0
 local canslam=true
 local CLEAR='clear-lines-sfx'
 local BlAME='slam-block-sfx'
 local combo={
  timer=0,
  timeto=60*6,
  count=1
 }

 local function comboTimeTo()
  return combo.timeto-(combo.count-1)*30
 end

 local function updateCombo()
  if combo.timer<=0 then
   combo.count=1
  else
   combo.timer=combo.timer-1
  end
 end
 Somchi.add(0,CLEAR,20,30)
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
 tp.hei=12
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
  --+(s.wid+2.5)*4
  local x,y=s.pos.x+2,(s.hei+2)*8
  CPrint('PLAYER '..s.id,x,y,1,12,true)
  CPrint('SCORE: '..s.score,x,y+7,1,12,true)
  CPrint('LINES: '..s.lines,x,y+14,1,12,true)
  ProgressBar(Vectic.new(x+47,y),combo.timer,comboTimeTo(),Vectic.new(20,5),6,14)
  -- CPrint(combo.timer,x+8*s.wid,y,1,12,true)
  CPrint(combo.count,x+8*s.wid,y+7,1,12,true)
 end

 ---@param s TriPlayer
 tp.drawBoard=function(s)
  for _,p in ipairs(s.tri.blocks) do
   Trimino.draw(p.x*8,p.y*8,s.block[s.tri.type].id,s.block[s.tri.type].color)
  end

  for x,t in ipairs(s.board) do
   for y,c in ipairs(t) do
    if c=='i' then
     Trimino.draw(x*8,y*8,s.block.i.id,s.border.color)
    elseif c=='l' then
     Trimino.draw(x*8,y*8,s.block.l.id,s.border.color)
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
  if btnp(cmod+4) then
   Trimino.rotate(tp.tri)
  end
  if not btn(cmod) then
   canslam=true
  end
  if canslam and btn(cmod) then
   Trimino.move(tp.tri,'y',1)
  end
  if downdelay<downcount then
   if btn(cmod+1) then
    downcount=0
    Trimino.move(tp.tri,'y',1)
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
  return lines*10*combo.count
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
     Somchi.play(CLEAR,0,20+5*#cleared)
     playsfx=false
     combo.count=combo.count+#cleared
     combo.timer=comboTimeTo()
    end
    if fs%5==0 then 
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
   end)
  end
 end

 ---@param s TriPlayer
 tp.moveTri=function(s)
  local prev=clone(tp.tri.blocks)
  if spcount>s.speed then
   spcount=0
   Trimino.move(tp.tri,'y',1)
  end

  scanLines()

  pCtrl()

  if isBlockOut(tp.tri.blocks) or not isLegal(tp.tri.blocks) then
   if atBottom(prev) then
    tp.tri.blocks=prev
    local min,max=Trimino.bounds(prev)
    lock()
    Somchi.play(BlAME,2)
    Gochi.particles.sparks(
     Vectic.new(8*min.x+(8*max.x-8*min.x)/2,8*max.y),
     20,
     10,
     .5
    )
    tp.tri=Trimino.create()
    canslam=false
   else
    tp.tri.blocks=prev
   end
  end
 end

 ---@param s Gochi
 tp.run=function(s)
  spcount=spcount+1
  bpcount=bpcount+1
  downcount=downcount+1
  tp:moveTri()
  tp:drawBorder()
  tp:drawInfo()
  tp:drawBoard()
  updateCombo()
 end
 return tp
end