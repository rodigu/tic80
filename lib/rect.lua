---@type fun(p1:Vectic,p2:Vectic,p3:Vectic,p4:Vectic)
function drawRect(p1,p2,p3,p4)
 tri(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,12)
 tri(p1.x,p1.y,p3.x,p3.y,p4.x,p4.y,12)
end