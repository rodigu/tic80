p1=CreatePlayer(1, {
 l={color=3,id=256},
 i={color=2,id=257}
},{
 color=9,
 id=0
})

m=CreateMenu({makeMB('1 PLAYER'),makeMB('2 PLAYERS'),makeMB('SHOP'),makeMB('OPTIONS')},20,20)
Gochi.current=p1

function TIC()
 cls(0)
 Gochi:run()
end