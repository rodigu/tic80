---@module "vectic"

---@class Starfield
---@field stars Vectic[]
---@field minsize Vectic
---@field maxsize Vectic

local Starfield = {}

---@param s Starfield
---@param count number
---@param minsize Vectic
---@param maxsize Vectic
function Starfield.setup(s,count,minsize,maxsize)
 s.stars = {}
 s.minsize = minsize
 s.maxsize = maxsize
 for i=0,count do
  table.insert(s.stars, Vectic.rnd(minsize.x,maxsize.x,minsize.y,maxsize.y))
 end
end

---@param s Starfield
function Starfield.draw(s, move)
 for i,star in ipairs(s.stars) do
  circ(star.x,star.y,1,14)
  if move~=nil then
   local amount = -move / 25
   if i%3==0 then amount = -move / 15
   elseif i%2==0 then amount = -move / 20
   elseif i%5==0 then amount = -move / 4
   elseif i%7==0 then amount = -move / 6 
   elseif i%11==0 then amount=-move end

   star = star + amount
   if star.x < s.minsize.x then
    star.x = s.maxsize.x
    star.y = math.random(s.minsize.y, s.maxsize.y)
   elseif star.x > s.maxsize.x then
    star.x = s.minsize.x
    star.y = math.random(s.minsize.y, s.maxsize.y)
   end
   if star.y < s.minsize.y then
    star.y = s.maxsize.y
    star.x = math.random(s.minsize.x, s.maxsize.x)
   elseif star.y > s.maxsize.y then
    star.y = s.minsize.y
    star.x = math.random(s.minsize.x, s.maxsize.x)
   end
   s.stars[i] = star
  end
 end
end