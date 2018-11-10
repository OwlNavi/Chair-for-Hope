pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
player = {}
player.x = 20
player.y = 20
player.sprite = 0
player.speed = 4
player.direction = "still"
player.bubble = false
player.bubble_sprite = 34
player.cm = true //collide map
player.cw = true //collide world
mobcount = 5
function move()
	player.moving = true
	if player.direction == "left" or
		player.direction == "right" then
		 player.sprite += 2
		 if player.sprite > 6 then
		 	player.sprite = 2
		 end
		//end left/right
	elseif player.direction == "up" then
	 if player.sprite == 8 or
	 	player.sprite == 10 then
	 		player.sprite += 2
	 else
	 	player.sprite = 8
	 end //end up		
	elseif player.direction == "down" then
		if player.sprite == 0 then
			player.sprite = 14
		elseif player.sprite == 14 then
			player.sprite = 32
		else
			player.sprite = 0
		end
	end
end

function _draw()
	cls()
	camera(player.x-54,
	 player.y-54)
	map(0, 0, 0, 0, 128, 32)
	if player.direction == "right" then
	 spr(player.sprite, 
		 player.x,
		 player.y,
		 2,2)//2x2 sprite size
 else //flip to face left
 	spr(player.sprite,
 		player.x,
 		player.y,
 		2,2,
 		true, //flip x
 		false) //flip y
 end
 //draw bubble
 if player.bubble == true then
 	spr(player.bubble_sprite,
 		player.x,
 		player.y,
 		2,2)
 end
 
 //draw mobs
 for i=1,mobcount do
 	local mob = mobs[i]
 	spr(mob.sprite,
 		mobs[i].x,
 		mobs[i].y,
 		1,1)
 end
 
end

function _update()
	//print
	local x = "x:", tostr(player.x)
	print(x, player.x-10,
		player.y-10, 6)
	
	//update move
	player.moving = false
	if btn(0) then //left 
	 player.x -= player.speed
	 player.direction = "left"
		move()
		if cmap(player) then
			player.x += player.speed
		end
	end
	if btn(1) then //right
	 player.x += player.speed
	 player.direction = "right"
	 move()
	 if cmap(player) then
			player.x -= player.speed
		end
	end
	if btn(2) then
		player.y -= player.speed
		player.direction = "up"
		move()
		if cmap(player) then
			player.y += player.speed
		end
	end
	if btn(3) then 
		player.y += player.speed
		player.direction = "down"
		move()
		if cmap(player) then
			player.y -= player.speed
		end
	end
	if not player.moving then
		player.direction = "still"
		player.sprite = 0
	end
	if btn(4) then //z / c
		player.bubble = true
		player.cm = false
		if player.bubble_sprite == 34 then
			player.bubble_sprite = 36
		elseif player.bubble_sprite == 36 then
		 player.bubble_sprite = 38
		elseif player.bubble_sprite == 38 then
			player.bubble_sprite = 40
		else 
		 player.bubble_sprite = 34
		end
	else
		player.bubble = false
		player.cm = true
		end
	if btn(5) then
	end
	
	//move mobs
	for c=1,mobcount do
		local mob = mobs[c]
		local choice = flr(rnd(6))
		
		//change x velocity
		if choice == 0 then
			//down
			if mob.vy < 1 then
				mob.vy += mob.dy
			end
		elseif choice == 1 then
			//up
			if mob.vy > -1 then
				mob.vy -= mob.dy
			end
		elseif choice == 2 then
			//right
			if mob.vx < 1 then
				mob.vx += mob.dx
			end
		elseif choice == 3 then
			//left
			if mob.vx > -1 then
				mob.vx -= mob.dx
			end
		end
			
		//move mob and check collision
		mob.x += mob.vx * mob.speed
		
		if cmap2(mob) then
			mob.x -= mob.vx * mob.speed
		end
		mob.y += mob.vy * mob.speed
		if cmap2(mob) then
			mob.y -= mob.vy * mob.speed
		end
		
		end
end
-->8
w = 600
h = 600
function cmap(o)
  local ct=false
  local cb=false

  -- if colliding with map tiles
  if(o.cm) then
    local x1=o.x/8
    local y1=o.y/8
    local x2=(o.x+15)/8
    local y2=(o.y+15)/8
    local a=fget(mget(x1,y1),0)
    local b=fget(mget(x1,y2),0)
    local c=fget(mget(x2,y2),0)
    local d=fget(mget(x2,y1),0)
    ct=a or b or c or d
   end
   -- if colliding world bounds
   if(o.cw) then
     cb=(o.x<8 or o.x+8>w or
           o.y<8 or o.y+8>h)
   end

  return ct or cb
end
function cmap2(o)
  local ct=false
  local cb=false

  -- if colliding with map tiles
  if(o.cm) then
    local x1=o.x/8
    local y1=o.y/8
    local x2=(o.x+7)/8
    local y2=(o.y+7)/8
    local a=fget(mget(x1,y1),0)
    local b=fget(mget(x1,y2),0)
    local c=fget(mget(x2,y2),0)
    local d=fget(mget(x2,y1),0)
    ct=a or b or c or d
   end
   -- if colliding world bounds
   if(o.cw) then
     cb=(o.x<8 or o.x+8>w or
           o.y<8 or o.y+8>h)
   end

  return ct or cb
end
-->8
mobs = {}
spawn = {50,50, 75, 75, 220, 38,
	240, 120, 288, 18}
for i=1,mobcount do
	local mob = {}
	mob.sprite = 42
	mob.speed = 1
	mob.dx = 0.25
	mob.dy = 0.25
	mob.vx = 0
	mob.vy = 0
	mob.x = spawn[i]
	mob.y = spawn[i+1]
	mobs[i] = mob
	mob.cm = true //collide map
 mob.cw = true //collide world
	end


__gfx__
00044444444440000044000000000000004400000000000000440000000000000004444444444000000444444444400000044444444440000004444444444000
00044444444440000444400000000000044440000000000004444000000000000004444444444000000444444444400000044444444440000004444444444000
000444444444400044ff44000000000044ff44000000000044ff4400000000000004444444444000000444444444400000044444444440000004444444444000
04444444444444404f44f400000000004f44f400000000004f44f400000000000444444444444440044444444444444004444444444444400444444444444440
44ff44444444ff444f44f400000000004f44f400000000004f44f4000000000044444444444444444444444444444444444444444444444444ff44444444ff44
4f4f44444444f4f44f44f400000000004f44f400000000004f44f400000000004444444444444444444444444444444444444444444444444f4f44444444f4f4
4f4f44444444f4f44f44f404444444404f44f404444444404f44f404444444404444444444444444444444444444444444444444444444444f4f44444444f4f4
44ff44444444ff4444f44ffffffffff444f44ffffffffff444f44ffffffffff444444444444444444444444444444444444444444444444444ff44444444ff44
044ffffffffff44004f44444444444f404f44444444444f404f44444444444f4044444444444444004444444444444400444444444444440044ffffffffff440
004ffffffffff40004f44444444444f404f44444444444f404f44444444444f4004444444444440000444444444444000044444444444400004ffffffffff400
004f44444444f40004f4444444444f4004f4444444444f4004f4444444444f40004444444444440000444444444444000044444444444400004f44444444f400
004f44444444f40004f444444444f40004f444444444f40004f444444444f400004444444444440000444444444444000044444444444400004f44444444f400
004f44444444f40004f444444444f40004f444444444f40004f444444444f400004444444444440000444444444444000044444444444400004f44444444f400
004ffffffffff40004ffffffffff440004ffffffffff440004ffffffffff4400004444444444440000444444444444000044444444444400004ffffffffff400
00444444444444000044444444444000004444444444400000444444444440000044444444444400004444444444440000444444444444000044444444444400
00044000000440000044000000044000004400000000440000044000000004400004400000044000000044000000440000440000004400000000440000004400
00044444444440000088888888888800088444444444488000aaaaaaaaaaaa00000aa000000aa000044444400444440000000000000000000000000000000000
0004444444444000088444444444488080044444444440080aa0000000000aa000a0000000000a0044fff4444444444400000000000000000000000000000000
000444444444400088844444444448888004444444444000aaa0000000000aaa0a000000000000a000cffc044044444400000000000000000000000000000000
044444444444444084444444444444480444444444444440a00000000000000a0a000000000000a000ffff0000ffff0000000000000000000000000000000000
44ff44444444ff4444ff44444444ff4444ff44444444ff440000000000000000a00000000000000a049999400499994000000000000000000000000000000000
4f4f44444444f4f44f4f44444444f4f44f4f44444444f4f40000000000000000000000000000000a004994000099990000000000000000000000000000000000
4f4f44444444f4f44f4f44444444f4f44f4f44444444f4f40000000000000000000000000000000000bbbb000099990000000000000000000000000000000000
44ff44444444ff4444ff44444444ff4444ff44444444ff4400000000000000000000000000000000044004400440044000000000000000000000000000000000
044ffffffffff440844ffffffffff448044ffffffffff440a00000000000000a0000000000000000004444000044440000000000000000000000000000000000
004ffffffffff400884ffffffffff488004ffffffffff400aa000000000000aa000000000000000004ff44400444ff4000000000000000000000000000000000
004f44444444f400884f44444444f488804f44444444f408aa000000000000aaa00000000000000a00cf44400044fc4000000000000000000000000000000000
004f44444444f400884f44444444f488804f44444444f408aa000000000000aaaa0000000000000a00ffff0000ffff0000000000000000000000000000000000
004f44444444f400884f44444444f488804f44444444f408aa000000000000aa0aa00000000000a0049999000099994000000000000000000000000000000000
004ffffffffff400884ffffffffff488804ffffffffff408aa000000000000aa00a00000000000a0004499000099440000000000000000000000000000000000
0044444444444400084444444444448008444444444444800a000000000000a000aa000000000a0000bb99000099bb0000000000000000000000000000000000
00440000004400000084488888844800080440000004408000a00aaaaaa00a000000aa0000aaa000044004000040044000000000000000000000000000000000
bbbbbbbb4444543bb344544444445444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333334544443bb344445445444454000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444444444443bb344445444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444454444444543bb344544444445444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
454444444544443bb344444545444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444544444443bb344444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
544544445445443bb345454454454444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
444444444444443bb344444444444544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555555555555566666666655555555555555556555555565555556666666665555555666666666666666660000000000000000555555555555555555555555
65655555556555565555555555556555555565556565555565655556656555555565555655655556656555560000000000000000555555555565555555556555
65555555555555565555555555555555555555556555555565555556655555555555555655555556655555560000000000000000555555556555555555555555
65555555555556565655565556555555565555556555555565555556655555555555565655555656655556560000000000000000555555555555556556555555
65555655555555565555555555555555555555556555565565555656655556555555555655555556655555560000000000000000555555555556555555555555
65555555555555565555555555555655555556556555555565555556655555555555555655555556655555560000000000000000555555555555556555555655
65655555555655565556555555555555555555556565555565655556656555555556555655565556655655560000000000000000555555555655555555555555
65555555555555565555555566666666556555556666666665555556655555556666666655555556666666660000000000000000555555555555555555655555
cc111111cccccccc1111111c11111111cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c111c111ccc11cc1111111cc1cc11111cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc1111c1111111111c11111c11111111cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccc11111111c11111111111c11c11c11cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccc11111111111111111c1cc11111111cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c111c111111111111c1111cc11111111cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc111111c11111c11111111c11ccc11ccccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c111111111111100000000b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3b3
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4b4
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646
4646464646464646464646b4b4b4b400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
46464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464646464600000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a646464646464646464646a6a6a6a6a6a6a6a6a646464646464646a6a6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6a6d6a6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6a6a646a6d6d6d6d6d6a646464646464646a6d6d6d6d6a64646464646d646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6a6d6a6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646a6d6d6d6d6d6a646464646464646a6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6a6d6a6d6d6d6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6d6d6d6d6d6d6d6a6d6d6d6d6a6a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6a646a6d6d6d6d6d6a646a6a6a6a6a6a6a6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6a6a6a6d6d6d6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6d6d6d6d6d6d6d6a6d6d6d6d6a646a6d6d6a6a6a6a6a6a6a6a6a6d6d6a6a6a6d6d6d6a6a6a646a6d6d6d6d6d6d6d6d6d6d6a646d64646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6a6a6d6d6a646464646464646a6d6d6d6d6d6d6d6d6a6464646a6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646a6d6d6d6d6d6d6d6d6a646464646464646a6d6d6d6d6d6d6d6d6a6464646a6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6d6d6d6a646464646a6d6d6d6d6d6d6d6d6a646464646464646a6d6d6d6a6a6a6d6d6a6464646a6d6d6d6d6d6a6a6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6a64646464646464646464646464646a6d6d6d6a646464646a6d6d6a6a6a6a6a6a6a6a6a6a6a6a6a646a6a6d6d6a646a6d6d6a6a6a6a6a6d6d6d6d6d6a6a6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6a64646464646464646464646464646a6d6d6d6a646464646a6d6d6a64646464646a6d6d6d6d6d6a64646a6d6d6a646a6d6d6d6d6d6d6d6d6d6d6d6d6a6a6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6a64646464646464646464646464646a6d6d6d6a646464646a6d6d6a64646464646a6d6d6d6d6d6a6a6a6a6d6d6a646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6a646464646e6464646464646464646a6d6d6d6a646464646a6d6d6a64646464646a6d6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6d6d6d6d6d6a6a6a6a6a6a6464646464646464646a6d6d6d6a6a6a6a6a6a6d6d6a6a6a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6a64646464646464646a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6a6d6d6d6a6d6d6d6d6d6d6d6d6d6d6a6a6d6d6d6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6a64646464646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6464646464646464646a6a6d6d6a6d6d6d6d6d6d6d6d6d6d6a6a6d6d6d6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a64646464646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646a6d6d6a6d6d6d6d6d6d6d6d6d6d6a6a6d6d6d6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6a6a6a6a6d6d6d6a646e6464646464646a6d6d6a6a6a6a6a6a6a6a6a6a6a6a6a6d6d6a646464646a6a6a6a6a646a6d6d6a6d6d6a6a6a6a6a6d6d6d6a6a6d6d6d6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6a646e6a6d6d6d6a646464646a6a6a6a6a6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6d6d6d6a646a6d6d6a6d6d6a6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6a6a6a6a6a6a646e6a6a6d6d6a6a6a6a6a6a6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6d6d6d6a6a6a6d6d6a6a6a6a6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6a6a6a6a6a6a6464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6a6464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a6a6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6a6464646a6d6d6a6a6a6a6a6a6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6d6d6d6a6a6a6d6d6a6a6a6a6a6d6d6a6d6d6d6d6d6d6d6d6d6d6d6a64646d646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6d6d6d6d6d6d6d6d6a6464646a6d6d6a646464646a6a6a6a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646a6a6a6a6a646a6d6d6a64646a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6d6d6d6a6464646a6d6d6a646464646e6464646464646a6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a646464646464646464646a6d6d6a64646a6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6464646a6a6a6d6d6d6a6464646a6d6d6a64646a6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6d6d6d6d6d6d6d6a6a6a6a6a6a6a6a6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6464646a6d6d6d6d6d6a6464646a6d6d6a64646a6d6d6d6d6d6d6d6a6a6d6d6a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6464646a6d6d6d6d6d6a6a6a6a6a6d6d6a6a6a6a6d6d6d6d6d6d6d6a6a6d6d6a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6d6d6a6a6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464646464646464646400000000000000000000000000000000000000000000000000
6464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6d6d6a6a6d6d6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6d6d6a6a6a6a6a6a6a6a6a6a6a6a6d6d6d6a6a6a6a6a6a6a6a6a646464646464646464646464646464646464000000000000000000000000000000000000000000000000000000000000000000
6464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6d6d6a6a6d6d6a64646464646464646464646464646a6d6d6a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6a6a6d6d6d6d6d6d6a646464646464646464646464646464646464000000000000000000000000000000000000000000000000000000000000000000
6464646a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a64646464646464646464646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464000000000000000000000000000000000000000000000000000000000000000000
646464646464646464646464646464646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a64646464646464646464646464646a6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6d6a646464646464646464646464646464646464000000000000000000000000000000000000000000000000000000000000000000
6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a6a646464646464646464646464646464646464000000000000000000000000000000000000000000000000000000000000000000
