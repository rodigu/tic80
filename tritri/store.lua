Strg={}

Strg.BORDERS=6
Strg.BLOCKS=5

---@class PlayerStore
---@field high integer
---@field l Block
---@field i Block
---@field border Block

---@param tp TriPlayer
Strg.save=function (tp,high)
 local ploc=(tp.id-1)*(7+Strg.BLOCKS+Strg.BORDERS)
 pmem(ploc,high)
 pmem(ploc+1,tp.block.l.id)
 pmem(ploc+2,tp.block.l.color)
 pmem(ploc+3,tp.block.i.id)
 pmem(ploc+4,tp.block.i.color)
 pmem(ploc+5,tp.border.id)
 pmem(ploc+6,tp.border.color)
end

---@param p integer
---@return PlayerStore
Strg.load=function(p)
 local ploc=(p-1)*(7+Strg.BLOCKS+Strg.BORDERS)
 local s={
  high=pmem(ploc),
  l={id=pmem(ploc+1),color=pmem(ploc+2)},
  i={id=pmem(ploc+3),color=pmem(ploc+4)},
  border={id=pmem(ploc+5),color=pmem(ploc+6)}}
 return s
end

---@param p integer Player number id
---@param blck integer Block number (starts at 1)
Strg.unlockBlock=function (p,blck)
 local ploc=(p-1)*(7+blck)
 pmem(ploc,1)
end

---@param p integer Player number id
---@param blck integer Block number (starts at 1)
Strg.hasBlock=function (p,blck)
 local ploc=(p-1)*(7+blck)
 pmem(ploc)
end

---@param p integer Player number id
---@param brdr integer Border number (starts at 1)
Strg.unlockBorder=function (p,brdr)
 local ploc=(p-1)*(7+Strg.BLOCKS+brdr)
 pmem(ploc,1)
end

---@param p integer Player number id
---@param brdr integer Border number (starts at 1)
Strg.hasBorder=function (p,brdr)
 local ploc=(p-1)*(7+Strg.BLOCKS+brdr)
 pmem(ploc)
end