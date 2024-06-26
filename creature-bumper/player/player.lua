function createPlayer()
 local p={
  weapon=Hams.get(0),
  armor=Arm.get(0),
  maxhp=3,
  hp=3,
 }

 p.atk=function()
  return p.weapon.atk
 end

 p.def=function()
  return p.armor.def
 end

 return p
end