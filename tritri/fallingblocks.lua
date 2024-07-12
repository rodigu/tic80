function genfallblock(bcount)
 bcount = bcount or 30
 local unlocked = math.floor(Strg.loadtotal()/10000)
 local blocks={}
 for i=0,bcount do
  blocks[i]={
   pos=Vectic.rnd(0,WID,0,HEI),
   vel=math.random()+.1,
   id=math.random(256,256+unlocked),
   col=math.random(1,14)
  }
 end

 local function genblck()
  return {
   pos=Vectic.rnd(0,WID,-12,-10),
   vel=math.random()+.1,
   id=math.random(256,256+unlocked),
   col=math.random(1,14)
  }
 end

 return {
  run=function ()
   for i=0,bcount do
    local b=blocks[i]
    pal(12,b.col)
    spr(b.id,b.pos.x,b.pos.y,0,2)
    b.pos.y=b.pos.y+b.vel
    if b.pos.y>HEI then
     blocks[i]=genblck()
    end
   end
  end
 }
end