---@module "aux.vectic"
---@module "garde"

local g1 = Garde.new(240/2,136/2)
Starfield:setup(200,Vectic.new(-240,-136),Vectic.new(2*240,2*136))

function TIC()
 cls()
 Starfield:draw(g1.vel)
 g1:draw(Starfield.maxsize/4)
 g1:move()
end