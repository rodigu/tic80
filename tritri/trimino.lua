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