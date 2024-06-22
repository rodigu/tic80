function openinggen()

 Gochi:add('opening-sequence', 1, Gochi.void, function ()
  Gochi.trans(menugen,30)
 end, 120)

 local basex=96
 local spd=5
 local tri={
  t={l='t',shook=false,v=Vectic.new(basex,-50)},
  r={l='r',shook=false,v=Vectic.new(basex+8*3,-150)},
  i={l='i',shook=false,v=Vectic.new(basex+8*5,-250)},
 }

 local moveletter=function(l)
  if l.v.y>HEI/2-16 then
   if not l.shook then
    Gochi:shake('letter-shake-intro-'..l.l,l.v,5,1)
    l.shook=true
   end
   return
  end
  l.v.y=l.v.y+spd
 end

 return {
  ---@param gc Gochi
  run=function (gc)
   spr(480, tri.t.v.x, tri.t.v.y, 0, 1, 0, 0, 3, 2)
   spr(483, tri.r.v.x, tri.r.v.y, 0, 1, 0, 0, 2, 2)
   spr(485, tri.i.v.x, tri.i.v.y, 0, 1, 0, 0, 1, 2)
   moveletter(tri.t)
   moveletter(tri.r)
   moveletter(tri.i)
  end
 }
end