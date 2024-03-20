p1=CreatePlayer('PLAYER 1', {
 l={color=3,id=256},
 i={color=2,id=256}
},{
 color=9,
 id=0
})

p1.board[2][2]='l'

function TIC()
 cls(0)
 Gochi:run()
 p1:run()
end