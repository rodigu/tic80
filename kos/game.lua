---@module "aux.vectic"
---@module "garde"

local g1 = Garde.new(240/2,136/2)

function TIC()
 cls()
 g1:draw()
 g1:move()
end