WID=240
HEI=136

function pal(c0,c1)
 if(c0==nil and c1==nil)then for i=0,15 do poke4(0x3FF0*2+i,i)end
 else poke4(0x3FF0*2+c0,c1) end
end

function indexOf(array, value)
 for i, v in ipairs(array) do
  if v == value then return i end
 end
 return nil
end

function CPrint(txt,x,y,scale,color,notcenter)
 local w=print(txt,WID,HEI,color,true,scale,true)
 if notcenter then w=0 end
 print(txt,x-w/2,y,color,true,scale,true)
end

function splitStr (inputstr, sep)
 if sep == nil then
  sep = "%s"
 end
 local t={}
 for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
  table.insert(t, str)
 end
 return t
end

---@type fun(pos:Vectic,curr:number,max:number,size:Vectic,col:number,bck_col?:number)
function ProgressBar(pos,curr,max,size,col,bck_col)
  if bck_col==nil then bck_col=12 end
  if col==nil then col=6 end
  rect(pos.x-1,pos.y-1,size.x+2,size.y+2,bck_col)
  rect(pos.x,pos.y,size.x*curr/max,size.y,col)
end
