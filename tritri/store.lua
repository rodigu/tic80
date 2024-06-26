Strg={}

---@class PlayerStore
---@field high integer
---@field l Block
---@field i Block
---@field border Block

Strg.setmem=function(do_force)
 for i=1,4 do
  if (do_force )or (not Strg.has(i)) then
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

Strg.savetotal=function(new_total)
 pmem(200,new_total+Strg.loadtotal())
end

Strg.loadtotal=function()
 return pmem(200)
end

---@param p integer
---@return PlayerStore
Strg.load=function(p)
 local ploc=(p-1)*(8)
 local s={
  high=pmem(ploc),
  l={id=pmem(ploc+1) or 256,color=pmem(ploc+2) or 2},
  i={id=pmem(ploc+3) or 257,color=pmem(ploc+4) or 6},
  border={id=pmem(ploc+5) or 0,color=pmem(ploc+6) or 14}}
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
