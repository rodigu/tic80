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

 ---@param s TriPlayer
 tp.run=function(s)
  s:drawBorder()
  s:drawInfo()
  s:drawBoard()
 end
 return tp
end