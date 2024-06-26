Hams={}

Hams.list={}

Hams.add=function(knock,atk)
 table.insert(Hams.list,{knock=knock,atk=atk})
end

Hams.get=function(id)
 return Hams.list[id]
end