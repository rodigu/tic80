---@class Trimino
Trimino={}

---@class TriPiece
---@field str string[]
---@field type 'l'|'i'

---@param piece TriPiece
Trimino._ri=function(piece)
 if piece[2]=='1' then
  return splitStr('0 0 0 i i i 0 0 0')
 else return splitStr('0 i 0 0 i 0 0 i 0')
 end
end

---@param piece TriPiece
Trimino._rl=function(piece)
  local hole=indexOf(piece.str,'0')
  local newhole=(indexOf(piece.str,'0')+1)%(1+#piece.str)
  local newstr={}
  for i,_ in ipairs(piece.str) do
   if newhole==i then newstr[i]='0'
   else newstr[i]='l' end
  end
  return newstr
end

---@param piece TriPiece
Trimino.rotate=function(piece)
 local rotstr={}
 if piece.type=='l' then
  rotstr=Trimino._rl(piece)
 else
  rotstr=Trimino._ri(piece)
 end
 piece.str=rotstr
end

---@param pos Vectic
Trimino.draw=function(x,y,id,color)
 pal(12,color)
 spr(id,x,y,0)
 pal()
end