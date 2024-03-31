for i=1,4 do
 local k=Strg.load(i)
 if k==0 then
  Strg.save(CreatePlayer(i, {
   l={color=3,id=256},
   i={color=2,id=257}
  },{
   color=14,
   id=0
  }),0)
 end
end

Gochi.current=menugen()

function TIC()
 cls(0)
 Gochi:run()
end