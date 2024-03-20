---@class Somchi
Somchi = {}

---@class Som
---@field id integer
---@field note integer
---@field duration number
---@field speed number

---@type table<string,Som>
Somchi.sounds = {}

---@type integer
Somchi.volume=10

---@type fun(id:integer,name:string,note:integer,duration?:number,speed?:number)
Somchi.add=function(id,name,note,duration,speed)
 duration=duration or -1
 speed=speed or 0
 Somchi.sounds[name] = {
  id=id,
  note=note,
  duration=duration,
  speed=speed
 }
end

---@type fun(name:string,channel?:integer,note?:integer,duration?:number,speed?:number)
Somchi.play=function(name,channel,note,duration,speed)
 local som=Somchi.sounds[name]
 duration=duration or som.duration
 speed=speed or som.speed
 note=note or som.note
 channel=channel or 0
 sfx(som.id,note,duration,channel,Somchi.volume,speed)
end