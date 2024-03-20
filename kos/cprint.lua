function CPrint(txt,x,y,scale,color)
 local w=print(txt,WID,HEI,color,true,scale,true)
 print(txt,x-w/2,y,color,true,scale,true)
end