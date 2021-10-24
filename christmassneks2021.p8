pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
--by jenny schmidt (bikibird)
--for christmas 2021

black,dark_blue,dark_purple,dark_green,brown,dark_gray,light_gray,white,red,orange,yellow,green,blue,indigo,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
left,right,up,down,fire1,fire2=0,1,2,3,4,5
becalmed=6
buttons={}
buttons[1]=left; buttons[2]=right; buttons[4]=up; buttons[8]=down
bulb_colors={green,red,blue,yellow}
bulb_blink={dark_green,pink,dark_blue,brown}
sparks={black,black,black,yellow}
flash_pattern={0,1,4}
crackle_pattern={0,39}
-->8
--initialize
function _init()
	reverse=false
	express=false
	

	flash_wait=.1
	flash_time=time()
	gameover=false

	init_snek_yard()
	_update=update_snek_yard
	_draw=draw_snek_yard
end	
function init_bulbs()
	bulbs={}
	for i=0,3 do
		local bulb=get_empty_cell()
		if (bulb) then
			bulb.s=flr(rnd(4))*5 +4
			mset(bulb.x,bulb.y,bulb.s)
			add(bulbs,bulb)
		end	
	end
end
function init_snek()
	snek={{x=60,y=60,s=flr(rnd(4))*5,aim=becalmed,train=false, wire={x0=64, y0=64, x1=64,y1=64}}}
	tongue={x=64,y=59,x0=64,y0=59,x1=64,y1=59,x2=64,y2=59,x3=64,y3=59,c0=black,c1=black,c2=black,c3=black,}
end	
-->8
--intro
function update_intro()
	if btnp(fire2) then
		init_snek_yard()
		_update=update_snek_yard
		_draw=draw_snek_yard
		init_forest()
	 
	end
end

function draw_intro()
	draw_snowscape()
	print(" tis the season to sing carols,",0,4,white)
	print("     drink nog, and decorate ",0,12)
	print(" the night with christmas sneks",0,20)
	print("        press X to play",4,119,dark_blue)
end

-->8
-->snek
function update_snek()
	if (short==0)then
			
		travel(snek[#snek])
	else
		short_circuit(snek[#snek])
	end	
	update_burnout()
end
function slither()
	local dy, dx, c, gridx, gridy,aim
	for i=#snek-1,1,-1 do
		gridx=flr((snek[i].x+3)/8)
		gridy=flr((snek[i].y+3)/8)
		
			social_distance(i,10)
	end
	for i=#snek-1,1,-1 do
		snek[i].wire={x0=snek[i].x+4,y0=snek[i].y+4,x1=snek[i+1].x+3,y1=snek[i+1].y+3}
	end
	if (not express) then
		for i=#snek-1,1,-1 do
			if(tongue.x>=snek[i].x) then
				if (tongue.x<snek[i].x+8) then
					if (tongue.y>=snek[i].y) then	
						if(tongue.y<snek[i].y+8) then
							short=i
							break
						end	
					end
				end		
			end
		end
	end	
end	
function social_distance(i,distance)
	dx=snek[i+1].x - snek[i].x
	dy=snek[i+1].y - snek[i].y
	c=sqrt(dx*dx+dy*dy)
	if (c>distance) then
		snek[i].x=snek[i+1].x-dx/c*distance
		snek[i].y=snek[i+1].y-dy/c*distance
	end
end
function travel(head)
	if (head) then
		if (btn(left)) then
			head.aim=left
		elseif (btn(right)) then
			head.aim=right
		elseif (btn(up)) then
			head.aim=up
		elseif (btn(down)) then
			head.aim=down
		end	
		if (head.aim==left) then
			head.x-=speed
		elseif (head.aim==right) then
			head.x+=speed
		elseif (head.aim==up) then
			head.y-=speed
		elseif (head.aim==down) then	
			head.y+=speed
		end
		update_tongue(head)
		update_growth(head)
		slither()
	end
end

function short_circuit()
	local head=snek[#snek]
	if (#snek>=short) then
		add(burnouts,deli(snek,short))
		burnouts[#burnouts].wait=.01+rnd(2)*.01
		burnouts[#burnouts].time=time()
	end
	if (#snek<short) then
		short=0
		if (#snek>0) then
			local new_head=snek[#snek]
			new_head.aim=head.aim
			speed=1.5
			for bulb in all(snek) do
				bulb.train=false
			end
			boarding=false
			new_head.wire={x0=new_head.x+4, y0=new_head.y+4,x0=new_head.x+4, y0=new_head.y+4}
			update_tongue(new_head)

		end	
	end	
end	
function update_burnout()
	if (#burnouts>0)then
		burnout=burnouts[1]
		if (burnout.s%5==3) then
			sfx(48)
		end	
		if (time()-burnout.time>burnout.wait) then
			burnout.s+=1
			burnout.time=time()
		end	
		if (burnout.s%5==4)then
			deli(burnouts,1)
		end	
		if (#burnouts==0 and #snek==0) then
			gameover_time=time()
		end	
	elseif(#snek==0) then	
		local timing=time()-gameover_time
		if (timing >.4 and timing <.5) then
			mset(9,13,0)
			sfx(48)
		elseif (timing >.5 and timing <.6) then
			mset(7,7,0)
			sfx(48)
		elseif (timing >.6 and timing <.7) then
			mset(4,3,0)
			sfx(48)		
		elseif(timing>1 and timing<5)then
			for i=0,5 do
				local gridx=flr(rnd(16))
				local gridy=flr(rnd(16))
				mset(gridx,gridy,0)
				sfx(48)
			end
		elseif (timing>5) then
			gameover=true
		end	
	end	
end

function update_growth(head)
	local gridx=flr(tongue.x/8)
	local gridy=flr(tongue.y/8)
	if (fget(mget(gridx,gridy))==1) then
		for i, bulb in pairs(bulbs) do
			if (bulb.x==gridx and bulb.y == gridy) then
				bulb.s=flr(bulb.s/5)*5
				bulb.aim=head.aim
				bulb.x*=8
				bulb.y*=8
				bulb.wire={x0=bulb.x,y0=bulb.y,x1=bulb.x,y1=bulb.y}
				bulb.train=false
				add(snek,bulb)
				deli(bulbs,i)
				break
			end
		end
		mset(gridx,gridy,26)
		sfx(41)
	end
end
function update_tongue(head)
	if (head.aim==up) then
		tongue={
			x=head.x+3.5, y=head.y-1,
			x0=head.x+3.5-flr(rnd(2)), y0=head.y-2-flr(rnd(2)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+3.5+flr(rnd(2)), y1=head.y-2+flr(rnd(2)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+3.5-flr(rnd(2)), y2=head.y-2+flr(rnd(2)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+3.5+flr(rnd(2)), y3=head.y-2-flr(rnd(2)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==down) then
		tongue={
			x=head.x+3.5, y=head.y+8,
			x0=head.x+3-flr(rnd(2)),y0=head.y+9-flr(rnd(2)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+4+flr(rnd(2)),y1=head.y+9+flr(rnd(2)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+3-flr(rnd(2)),y2=head.y+9+flr(rnd(2)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+4+flr(rnd(2)),y3=head.y+9-flr(rnd(2)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==left) then
		tongue={
			x=head.x-1, y=head.y+3.5,
			x0=head.x-2-flr(rnd(2)), y0=head.y+3-flr(rnd(2)), c0=sparks[flr(rnd(4))+1],
			x1=head.x-2+flr(rnd(2)), y1=head.y+4+flr(rnd(2)), c1=sparks[flr(rnd(4))+1],
			x2=head.x-2+flr(rnd(2)), y2=head.y+3-flr(rnd(2)), c2=sparks[flr(rnd(4))+1],
			x3=head.x-2-flr(rnd(2)), y3=head.y+4+flr(rnd(2)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==right) then
		tongue={
			x=head.x+8, y=head.y+3.5,
			x0=head.x+9-flr(rnd(2)), y0=head.y+3-flr(rnd(2)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+9+flr(rnd(2)), y1=head.y+4+flr(rnd(2)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+9+flr(rnd(2)), y2=head.y+3-flr(rnd(2)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+9-flr(rnd(2)), y3=head.y+4+flr(rnd(2)), c3=sparks[flr(rnd(4))+1]
		}
		
	end
end
function draw_snek()
	
	for i=1,#snek-1 do
		local wire=snek[i].wire
		line(wire.x0,wire.y0,wire.x1,wire.y1,dark_purple)
	end
	for i=1,#snek do
		spr(snek[i].s,snek[i].x,snek[i].y)	
	end
	if (#snek>0) then
		pset(tongue.x0, tongue.y0,tongue.c0)
		pset(tongue.x1, tongue.y1,tongue.c1)
		pset(tongue.x2, tongue.y2,tongue.c2)
		pset(tongue.x3, tongue.y3,tongue.c3)
	end	
	for burnout in all(burnouts) do
		spr(burnout.s,burnout.x,burnout.y)
	end
end	
-->8
--snek yard
function init_snek_yard()
	speed=1.5
	short=0
	offset=0
	burnouts={}
	boarding=false
	init_snek()
	init_bulbs()
end	
function update_snek_yard()
	if (btnp(fire2)and not gameover) then
		express=true
		gaze_time=time()
		gaze_wait=2
		for bulb in all(snek) do
			bulb.train=false
			add(lights,{x=bulb.x,y=bulb.y,c=flr(bulb.s/5)+1})
		end
		music(39)
	end	
	update_snek()
	if (#bulbs <4) then
		local bulb=get_empty_cell()
		if (bulb) then
			bulb.s=flr(rnd(4))*5 +4
			mset(bulb.x,bulb.y,bulb.s)
			add(bulbs,bulb)
		end
	end		
end
function draw_snek_yard()
	cls()
	map(0,0)
	if (gameover) then
		print("           game over", 0,56, red)
		print("         P - play again", 0,64,red)
	else
		draw_snek()
	end	
end
function get_empty_cell()
	local gridx=flr(rnd(14)+1)
	local gridy=flr(rnd(14)+1)
	--local counter =0
	local snekx=flr(snek[1].x/8)
	local sneky=flr(snek[1].y/8)
	if ((snek_zone(gridx,gridy))) then
			return (false)
	else		
		return {x=gridx,y=gridy}
	end
	
end
function snek_zone(x,y)
	local gridx0, gridy0, gridx1, gridy1
	for bulb in all(snek) do
		gridx0=flr((bulb.x)/8)
		gridy0=flr((bulb.y)/8)
		gridx1=flr((bulb.x+8)/8)
		gridy1=flr((bulb.y+8)/8)
		if (gridx0==x and gridy0==y) then
		 return true
		end
		if (gridx1==x and gridy0==y) then
			return true
		end
		if (gridx0==x and gridy1==y) then
			return true
		end
		if (gridx1==x and gridy1==y) then
			return true
		end
	end
	--space to move forward 
	gridx0=flr((snek[1].x-4)/8)
	gridy0=flr((snek[1].y-4)/8)
	gridx1=flr((snek[1].x+12)/8)
	gridy1=flr((snek[1].y+12)/8)
	if (gridx0==x and gridy0==y) then
		return true
	end
	if (gridx1==x and gridy0==y) then
		return true
	end
	if (gridx0==x and gridy1==y) then
		return true
	end
	if (gridx1==x and gridy1==y) then
		return true
	end
	return false
end
__gfx__
003bb30000033000000330000300003000033000008ee80000088000000880000800008000088000001cc1000001100000011000010000100001100000499400
03b77b30033bb33003377330000000000333333008e77e80088ee88008877880000000000888888001c77c10011cc110011771100000000001111110049aa940
3b7bb7b333b77b333377773300330300333bb3338e7ee7e888e77e888877778800880800888ee8881c7cc7c111c77c111177771100110100111cc11149a99a94
b7b77b7b3b7777b3377777733003b30333bbbb33e7e77e7e8e7777e8877777788008e80888eeee88c7c77c7c1c7777c1177777711001c10111cccc119a9aa9a9
b7b77b7b3b7777b337777773003bb30033bbbb33e7e77e7e8e7777e887777778008ee80088eeee88c7c77c7c1c7777c117777771001cc10011cccc119a9aa9a9
3b7bb7b333b77b333377773300033300333bb3338e7ee7e888e77e888877778800088800888ee8881c7cc7c111c77c111177771100011100111cc11149a99a94
03b77b30033bb33003377330000000300333333008e77e80088ee88008877880000000800888888001c77c10011cc110011771100000001001111110049aa940
003bb30000033000000330000300300000033000008ee80000088000000880000800800000088000001cc1000001100000011000010010000001100000499400
00044000000440000400004000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04499440044994400000000004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
449aa9444497794400440400444aa444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49aaaa94497777944004940444aaaa44000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49aaaa94497777940049940044aaaa44000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
449aa9444497794400044400444aa444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04499440044994400000004004444440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00044000000440000400400000044000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0001000001000000000100000000010000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000