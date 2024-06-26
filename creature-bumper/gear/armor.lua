Arm={}

Arm.list={}

Arm.add=function(knock,def)
 table.insert(Arm.list,{knock=knock,def=def})
end

Arm.get=function(id)
 return Arm.list[id]
end