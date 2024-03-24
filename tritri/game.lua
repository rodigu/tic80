p1=CreatePlayer(1, {
 l={color=3,id=256},
 i={color=2,id=257}
},{
 color=14,
 id=0
})

p1.pos.x=(WID-p1.wid*8)/2-8
m=CreateMenu({makeMB('1 PLAYER'),makeMB('2 PLAYERS'),makeMB('SHOP'),makeMB('OPTIONS')},20,20)
Gochi.current=p1

function TIC()
 cls(0)
 Gochi:run()
end