p1=CreatePlayer('PLAYER 1', {
 l={color=3,id=256},
 i={color=2,id=256}
},{
 color=9,
 id=0
})

p1.board[2][2]='l'

m=CreateMenu({makeMB('1 PLAYER'),makeMB('2 PLAYERS'),makeMB('SHOP'),makeMB('OPTIONS')},20,20)

function TIC()
 cls(0)
 Gochi:run()
 p1:run()
 m:run()
end