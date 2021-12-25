pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--by jenny schmidt (bikibird)
--for christmas 2021
--this is the story ofa hard working elf 
--on christmas eve.  They never gave me
--their name.  I've been calling them blinky.
black,dark_blue,mid_blue,dark_green,brown,charcoal,gray,white,red,orange,yellow,green,blue,lavender,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
left,right,up,down,fire1,fire2=0,1,2,3,4,5
becalmed=6
buttons={}
buttons[1]=left; buttons[2]=right; buttons[4]=up; buttons[8]=down

sparks={yellow,black,black,orange}
yule_set={31, 47,63}

detect_star = function(x,y)
	if #snek>1 then
		if  x>36 and x < 40 and y >21  and y <25 then
			if plugged_in and not winner then
				frame=0
				if conflagration then
					uh_oh()
					
				else
					ho_ho_ho()
				end
				snek[#snek].aim=becalmed
				return true	
			else
				snek[#snek].aim=becalmed
				snek[#snek].x=36
				snek[#snek].y=21
				star_connected=true
				sfx(48)
				social_distance()
				reverse_snek()
				return true
			end		
		end
	end	
	return false
end
--robot={x=20,y=110,s={[0]=143,[1]=175,[2]=207},index=2}
detect_robot=function(x,y)
	local song =stat(54)
	if (y>109 and y< 127 and x>19 and x<28  ) then
		
		if plugged_in then
			if not (song > 21) then
				music(22)
				robot_on=true
			end
		else
			robot_on=false	
		end
		return true
	end
	if robot_on and not (song >21) then
		robot_on=false
	end	
	return false
end 
detect_bear=function(x,y)
	if (y>85 and y< 100 and x>104 and x<118 and plugged_in) then
		xray_bear=true
		xray[1]=bear_skeleton
		if (stat(46)!=46) sfx(46,0)
		return true
	else
		if (xray[1]==bear_skeleton)	then
			xray={}
			sfx(-1,0)
		end
		return false
	end	
end
detect_doll=function(x,y)
	
	if (x>6 and x<19 and y>44 and y< 64 and  plugged_in) then
		xray_doll=true	
			--sfx(-1,0)
			xray[1]=heart
			if (stat(46)!=46) sfx(46,0)
		return true
	else
		if (xray[1]==heart)	then
			xray={}
			sfx(-1,0)
		end
		return false
	end	
end

detect_diamond=function(x,y)
	if (y>102 and y< 120 and x>48 and x<65 and plugged_in) then
		xray_diamond=true
			xray[1]=diamond
			if (stat(46)!=46) sfx(46,0)
		return true
	else
		if (xray[1]==diamond) then
			xray={}
			sfx(-1,0)
		end
		return false
	end	
end

detect_shirt=function(x,y)
	
	if (y>87 and  y< 104 and x>39 and x<55 and plugged_in) then
		xray[1]=shirt
		xray_shirt=true
		if (stat(46)!=46) sfx(46,0)
		return true
	else
		if (xray[1]==shirt) then
			xray={}
			sfx(-1,0)
		end
		return false
	end	
end
detect_outlet = function(x,y)
	if #snek> 1 then
		if (y>81 and y<87 ) then 
			local new_x=0
			if (x<6 and x >2) then 
				new_x=2 
				speed=1.2
				low_voltage=true
				
			elseif(x >121 and x<125  ) then
				new_x=121
				speed=2.2
				high_voltage=true
				
			end	
			if new_x>0 then 
				snek[#snek].x=new_x 
				if y>84 then
					snek[#snek].y=83	
				else
					snek[#snek].y=81		
				end	
				social_distance()
				reverse_snek()
				if not plugged_in then
					plugged_in=true
					sfx(47)
					if star_connected==true then
						winner=true
						if conflagration then
							uh_oh()
						else
							ho_ho_ho()
						end
					end
				else --short circuit	
					short =1
				end
				return true
			else
				return false	
			end			
		else
			return false
		end
	end	
end

detect_candles = function(x,y)
	if plugged_in then
		if (y>45 and y<50 ) then 
			if (x>65 and x <69 and not left_candle_lit) then 
				mset(8,6,176)
				left_candle_lit=true
				return true
			elseif(x >114 and x<118 and not right_candle_lit ) then
				mset(14,6,206)
				right_candle_lit=true
				return true
			end	
		end
	end	
	return false
end

detect_log=function(x,y)
	if plugged_in and not fire_lit then
		if (x>84 and x <101 and y>84 and y<91) then
			fset(88, 128 )
			fset(90, 128 )
			fset(104, 128 )
			fset(105, 128 )
			fset(106, 128 )
			mset(11,10,63)
			fire_lit=true
			return true
		end
	end		
	return false
end	
detect_clock= function(x,y)
	if plugged_in and x\8==11 and y\8==6 then
		clockface=true
		if stat(54)==0 then
			music(13)
			big_ben= true
			return true
		end
	else
		clockface=false	
	end	
	return false
end	

function detect_collision(x,y)
	if (not detect_star(x,y)) then	
		if ( not detect_log(x,y)) then
			if (not detect_outlet(x,y)) then 
				if (not detect_candles(x,y)) then 
					if (not detect_clock(x,y)) then
						if (not detect_bear(x,y)) then
							if not (detect_doll(x,y)) then
								if not (detect_diamond(x,y)) then
									if not(detect_shirt(x,y)) then
										if not detect_robot(x,y) then
											if plugged_in and not star_connected then
												local gridx,gridy= x\8+48,y\8
												if fget(mget(gridx,gridy),0) then
													conflagration=true
													if (stat(46)!=41) sfx(41,0)
													mset(gridx,gridy,26)
												end	
											end	
										end	
									end	
								end
							end
						end
					end	
				end
			end
		end	
	end
end
function ho_ho_ho()
	winner=true
	star_connected=true
	create_achievements()

	sfx(-1)
	music(0,1000)
end	
function uh_oh()
	winner=true
	star_connected=true
	create_achievements()	

	sfx(-1)	
	music(8,1000)
end	
function robot_ambulator()
	local destinations=
	{
		[1]={x=20,y=98,dx=0,dy=-1,s={207,159,191}},
		[2]={x=32,y=98,dx=1,dy=0,s={143,57,58}},
		[3]={x=70,y=98,dx=1,dy=0,s={143,57,58},move_gifts=true},
		[4]={x=80,y=98,dx=1,dy=0,s={207,159,191}},
		[5]={x=128,y=98,dx=1,dy=0,s={143,57,58}}
	}
	local first_step=true

	for destination in all(destinations) do
		if destination.move_gifts then
			move_gifts=true
			mset(37,11,0)
			mset(37,12,0)
			mset(37,13,0)
			mset(38,11,0)
			mset(38,12,0)
			mset(38,13,0)
			mset(38,14,0)
			mset(39,12,0)
			mset(39,13,0)
			mset(39,14,0)
			mset(40,13,0)
			mset(40,14,0)
		end
		while not (robot.x ==destination.x and robot.y ==destination.y) do
			if frame%5==0 then
				robot.x+=destination.dx
				robot.y+=destination.dy
				if first_step then
					robot.s={destination.s[1],destination.s[2]}
				else
					robot.s={destination.s[1],destination.s[3]}
				end	
				first_step=not first_step
			end	
			yield()
		end
		
	end
end

function reverse_snek()
	if (not (star_connected and plugged_in)) then
		local temp={}
		for i=#snek,1,-1 do
			add(temp,snek[i])
		end
		snek=temp
	end
	snek[#snek].aim=becalmed
	update_tongue(snek[#snek])
	
	
end
function _init()
	music(-1)
	sfx(-1)
	xray={}
	bear_skeleton={s=66,x=103,y=86,w=2,h=2,x0=104,x1=118,y0=85,y1=102}
	shirt={s=218,x=40,y=88,w=2,h=3,x0=39,x1=54,y0=87,y1=110}
	diamond={s=160,x=50,y=105,w=2,h=1,x0=49,x1=65,y0=103,y1=114}
	heart={s=114,x=10,y=50,w=1,h=1,x0=7,x1=20,y0=44,y1=64}
	star=
	{
		palettes=
		{
			[0]={[orange]=yellow, [yellow]=white, [white]=orange},
			[1]={[orange]=yellow, [yellow]=orange, [white]=yellow},
			[2]={[orange]=orange, [yellow]=orange, [white]=orange}
		},
		index=2
	}
	fire=
	{
		palettes=
		{
			[0]={[orange]=orange, [yellow]=yellow},
			[1]={[orange]=yellow, [yellow]=orange},
			[2]={[orange]=orange, [yellow]=orange},
			[2]={[orange]=yellow, [yellow]=yellow}
		},
		index=0
	}
	bulb_palette=
	{
		palettes=
		{
			[0]={[white]=blue,[yellow]=blue},
			[1]={[yellow]=green},
			[2]={[white]=orange, [yellow]=orange},
			[3]={[pink]=red, [peach]=red, [white]=red},
		}
	}

	robot={x=20,y=110,s={[0]=143,[1]=175,[2]=207},index=2}

	achievements={}

	pal({[0]=0,1,140,3,4,5,6,7,8,9,10,11,12,13,14,15},1)
	light_palette={[0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
	dark_palette={[0]=black,dark_blue,black,charcoal,dark_blue,black,charcoal,black,black,black,black,black,black,black,black,black}
	intro_palette={[0]=black,dark_blue,lavender,dark_blue,dark_blue,black,dark_blue,black,black,black,black,black,black,black,black,black}

	frame=0
	big_ben=false
	bonfire=false
	clockface=false
	conflagration=false
	echolocator=false
	exploded_bulbs=0
	fire_lit=false
	fuses_blown=false
	gameover=false
	high_voltage=false
	intro =true
	move_gifts=false
	plugged_in=false
	left_candle_lit=false
	longest_snek=1
	low_voltage=false
	outro=false
	right_candle_lit=false
	robot_dance=false
	robot_on=false
	romantic=false
	short=0
	star_connected=false
	winner=false
	xray_bear=false
	xray_diamond=false
	xray_doll=false
	xray_shirt=false

	init_snek_yard()

	robot_step=cocreate(robot_ambulator)

	start=time()
end	
function init_bulbs()
	bulbs={}
	for i=0,3 do
		local bulb=get_empty_cell()
		if (bulb) then
			bulb.s=flr(rnd(4))+43
			add(bulbs,bulb)
		end	
	end
end



function init_snek()
	local base=flr(rnd(4))
	snek={{x=62,y=62,base=base,s=base+27,blink=false,frame=flr(rnd(3000)),aim=becalmed, wire={x0=64, y0=64, x1=64,y1=64}}}
	tongue={x=64,y=64,x0=64,y0=64,x1=64,y1=64,x2=64,y2=64,x3=64,y3=64,c0=black,c1=black,c2=black,c3=black,}
	
end	



function update_snek()
	if (short>0)then
		short_circuit(snek[#snek])
	end		
	travel(snek[#snek])
	echolocation()
	update_burnout()
	frame+=1
	if (frame >32700) frame=frame%32700
	if (frame%200==0) xray={}
	if (winner) then
		for bulb in all(snek) do
			if frame%bulb.frame==0 then
				bulb.blink=not bulb.blink
				if bulb.blink then
					bulb.frame=15*flr(rnd(2)+1)  
				else
					bulb.frame=15*flr(rnd(4)+1)
				end	
			end	
		end
	end	
end
function update_robot()
	if (winner) then
		if frame%5==0 then
			coresume(robot_step)
			
		end	
	else
		if robot_on and frame%10== 0 then
			robot.index=(robot.index+1)%2
		end
	end	
	
end
function echolocation()
	if #snek>0 then
		local x=snek[#snek].x
		local y=snek[#snek].y
		local dx, dy,song=0,0,0

		if (x<-4 ) then
			dx=x
		elseif (x>126)	then
			dx=(x-126)
		end
		if (y<-4 ) then
			dy=y
		elseif (y>126)	then
			dy=(y-126)
		end	
		local distance= abs(dx+dy)
		song=stat(54)
		if song ==20 or song ==21 then
		
			if distance >160 then
				poke(16196,193)  -- sfx 20
				poke(16264,193)  -- sfx 21
			elseif distance > 80 then
				poke(16196,137)
				poke(16264,137)
			elseif distance>0 then
				poke(16196,17)
				poke(16264,17)
			else
				music(-1)
			end	
		else
			if distance>0 then
				music(20)
				echolocator=true
			end	
		end
	end		
end
function slither()
	local dy, dx, c, gridx, gridy,aim
	detect_collision(tongue.x,tongue.y)
	if plugged_in or star_connected then
		pinned_social_distance()
	else
		social_distance(1)
	end	
	
	for i=#snek-1,1,-1 do
		snek[i].wire={x0=snek[i].x+3,y0=snek[i].y+3,x1=snek[i+1].x+2,y1=snek[i+1].y+2}
	end
	if (plugged_in) then
		for i=#snek-1,1,-1 do
			if(tongue.x>=snek[i].x) then
				if (tongue.x<snek[i].x+6) then
					if (tongue.y>=snek[i].y) then	
						if(tongue.y<snek[i].y+6) then
							short=i
							break
						end	
					end
				end		
			end
		end
	end	
	
		
end	
function social_distance()
	for i=#snek-1,1,-1 do 
		dx=snek[i+1].x - snek[i].x
		dy=snek[i+1].y - snek[i].y
		c=dx*dx+dy*dy
		if (c>49) then --distance =7 square distance 49
			c=sqrt(c)
			snek[i].x=snek[i+1].x-dx/c*7
			snek[i].y=snek[i+1].y-dy/c*7
		end
	end		
end
function pinned_social_distance() 
	for i=#snek-1,2,-1 do -- social distance starting at head and stop before tail
		dx=snek[i+1].x - snek[i].x
		dy=snek[i+1].y - snek[i].y
		c=dx*dx+dy*dy
		if (c>49) then --distance =7 square distance 49
			c=sqrt(c)
			snek[i].x=snek[i+1].x-dx/c*7
			snek[i].y=snek[i+1].y-dy/c*7
		end
	end	
	for i=1,#snek-1 do --social distance starting at tail to pull back if needed
		dx=snek[i].x - snek[i+1].x
		dy=snek[i].y - snek[i+1].y
		c=dx*dx+dy*dy
		if (c>49) then --distance =7 square distance 49
			c=sqrt(c)
			snek[i+1].x=snek[i].x-dx/c*7
			snek[i+1].y=snek[i].y-dy/c*7
		end
	end	

end

function travel(head)
	if (intro and (btnp(fire1) or btnp(fire2))) intro=false
	if (winner or gameover or fuses_blown) then
		if btnp(fire1) or btnp(fire2) then
			
			if outro then				
				reload()
				_init()
			else
				outro=true
			end	
		end
		return
	end	
	if (head) then
		if (btnp(left)) then
			head.aim=left
		elseif (btnp(right)) then
			head.aim=right
		elseif (btnp(up)) then
			head.aim=up
		elseif (btnp(down)) then
			head.aim=down
		elseif btnp(fire1 )  then
			plugged_in=false
			if (fire_lit or left_candle_lit or right_candle_lit) romantic=true
			if (conflagration) bonfire=true
		elseif btnp(fire2) then
			star_connected=false	
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
		exploded_bulbs+=1
		burnouts[#burnouts].wait=.2+rnd(5)*.01
		burnouts[#burnouts].time=time()
	end
	if (#snek<short) then
		short=0
		if (#snek>0) then
			local new_head=snek[#snek]
			new_head.aim=head.aim
			
			speed=1.2
			
			new_head.wire={x0=new_head.x+3, y0=new_head.y+3,x0=new_head.x+3, y0=new_head.y+3}
			if (plugged_in and #snek ==1) plugged_in=false
			update_tongue(new_head)

		end	
	end	
end	
function update_burnout()
	if (#burnouts>0)then
		burnout=burnouts[1]
		sfx(38)
	
		if (time()-burnout.time>burnout.wait) then

			deli(burnouts,1)

		end	
		if (#burnouts==0 and #snek==0) then
			gameover_time=time()
			fuses_blown=true
			create_achievements()
		end	
	elseif(#snek==0) then	
		local timing=time()-gameover_time
		if (timing >.4 and timing <.5) then
			mset(41,13,79)
			sfx(38,1)
		elseif (timing >.5 and timing <.6) then
			mset(42,7,79)
			sfx(38,1)
		elseif (timing >.6 and timing <.7) then
			mset(36,3,79)
			sfx(38,1)		
		elseif(timing>1 and timing<5)then
			for i=0,5 do
				local gridx=flr(rnd(16))
				local gridy=flr(rnd(16))
				mset(gridx+32,gridy,79)
				sfx(38,1)
			end
		elseif (timing>5) then
			gameover=true
			sfx(-1)
			music(-1)
		end	
	end	
end

function update_growth(head)
	local gridx=flr(tongue.x/6)
	local gridy=flr(tongue.y/6) 
	for i, bulb in pairs(bulbs) do  --check loose bulbs for connection to snek
		if (bulb.x==gridx and bulb.y == gridy) then  --found
			bulb.s=bulb.s-16 --row above
			bulb.base=bulb.s-27
			bulb.blink=false
			bulb.frame= 10+flr(rnd(300))
			bulb.aim=head.aim
			bulb.x*=6
			bulb.y*=6
			bulb.wire={x0=bulb.x,y0=bulb.y,x1=bulb.x,y1=bulb.y}
			add(snek,bulb)
			sfx(37,1)
			deli(bulbs,i)
			break
		end
	end
	if (#snek > longest_snek) longest_snek=#snek

end
function update_tongue(head)
	if (head.aim==up) then
		tongue={
			x=head.x+2.5, y=head.y-1,
			x0=head.x+flr(2.5-rnd(1)), y0=head.y-flr(2-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(2.5+rnd(1)), y1=head.y-flr(2+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(2.5-rnd(1)), y2=head.y-flr(2+rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(2.5+rnd(1)), y3=head.y-flr(2-rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==down) then
		tongue={
			x=head.x+2.5, y=head.y+6,
			x0=head.x+flr(2.5-rnd(1)),y0=head.y+flr(6-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(2.5+rnd(1)),y1=head.y+flr(6+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(2.5-rnd(1)),y2=head.y+flr(6+rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(2.5+rnd(1)),y3=head.y+flr(6-rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==left) then
		tongue={
			x=head.x-1, y=head.y+2.5,
			x0=head.x-flr(2-rnd(1)), y0=head.y+flr(2.5-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x-flr(2+rnd(1)), y1=head.y+flr(2.5+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x-flr(2+rnd(1)), y2=head.y+flr(2.5-rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x-flr(2-rnd(1)), y3=head.y+flr(2.5+rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==right) then
		tongue={
			x=head.x+6, y=head.y+2.5,
			x0=head.x+flr(6-rnd(1)), y0=head.y+flr(2.5-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(6+rnd(1)), y1=head.y+flr(2.5+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(6+rnd(1)), y2=head.y+flr(2.5-rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(6-rnd(1)), y3=head.y+flr(2.5+rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==becalmed)then
		tongue={
			x=head.x+2.5, y=head.y+2.5,
			x0=head.x, y0=head.y, c0=sparks[flr(rnd(4))+1],
			x1=head.x, y1=head.y, c1=sparks[flr(rnd(4))+1],
			x2=head.x, y2=head.y, c2=sparks[flr(rnd(4))+1],
			x3=head.x, y3=head.y, c3=sparks[flr(rnd(4))+1]
		}	
	
	end
end
function draw_snek()
	
	for i=1,#snek-1 do
		local wire=snek[i].wire
		if plugged_in then
			line(wire.x0,wire.y0,wire.x1,wire.y1,charcoal)
		else
			line(wire.x0,wire.y0,wire.x1,wire.y1,red)
		end
	end
	for i=1,#snek do
		if (not plugged_in) then
			
			spr(snek[i].s+48,snek[i].x,snek[i].y)
		else
			if (winner and snek[i].blink) then
				pal(bulb_palette.palettes[snek[i].base])
			else	
				pal(light_palette)
			end
			spr(snek[i].s,snek[i].x,snek[i].y)
		end	
	end
	if (plugged_in) pal(light_palette)
	if (#snek>0) then
		if snek[#snek].aim!=becalmed then
			if (not plugged_in ) then
				pset(tongue.x,tongue.y,red)
			else
				pset(tongue.x0, tongue.y0,tongue.c0)
				pset(tongue.x1, tongue.y1,tongue.c1)
				pset(tongue.x2, tongue.y2,tongue.c2)
				pset(tongue.x3, tongue.y3,tongue.c3)	
			end
		end	
	end	
	for burnout in all(burnouts) do
		spr(burnout.s+32,burnout.x,burnout.y)
	end
end	
function draw_bulbs()
	

	for i=1,#bulbs do
		pal(charcoal,black)
		if (not plugged_in) then
			
			spr(bulbs[i].s+48,bulbs[i].x*6,bulbs[i].y*6)	
			
		else
			spr(bulbs[i].s,bulbs[i].x*6,bulbs[i].y*6)
		end
	end
	pal(charcoal,charcoal)
end	
function init_snek_yard()
	speed=1.2
	short=0
	burnouts={}
	init_snek()
	init_bulbs()
end	
function _update()
	if (conflagration) coresume(update_flames)
	if frame%60==0 then
		star.index= (star.index+1)%2 
	end	
	update_snek()
	if (#bulbs <4) then
		local bulb=get_empty_cell()
		if (bulb) then
			bulb.s=flr(rnd(4))+43
			add(bulbs,bulb)
		end
	end	
	update_robot()
	if (fire_lit) mset(11,10,rnd(yule_set))
	
end

ignition={{x=-1,y=0},{x=1,y=0},{x=0,y=-1},{x=-1,y=0},{x=1,y=0},{x=0,y=-1},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},{x=0,y=0},false} ---left, right, top
flame_set={25,26,41,42}
function flame_generator()
	local ignite, tree,flame,tree_x, tree_y,i,j,kindling
	while true do
		
		for i=48,57 do
			for j=3,14 do
				flame=fget(mget(i,j),1)
				if flame then
					ignite=rnd(ignition)
					if (not ignite) then
						mset(i,j,0) --remove flames
						mset(i+16,j,mget(i-48,j)) --add ash tree						
						mset(i-48,j,0) --remove burnt tree
					else
						mset(i,j,rnd(flame_set))
						tree_x=i+ignite.x
						tree_y=j+ignite.y
						tree=fget(mget(tree_x, tree_y),0)
						if (tree) then
							mset(tree_x,tree_y,rnd(flame_set))
						end			
					end	
				end
			end	
		end
	
		yield()
	end	
end
update_flames=cocreate(flame_generator)
 
function create_achievements()
	local elapsed=time()-start
	local minutes=tostr(elapsed\60)
	local seconds=tostr(flr(elapsed+.5)%60)
	if (#minutes==0) minutes="0"
	if (#seconds<2) seconds="0"..seconds
	if (#seconds<2) seconds="0"..seconds
	add(achievements,{text="\fa★\fb", hidden="^",skip_hidden=false,locked=true})	--1

	add(achievements,{text=minutes..":"..seconds,hidden="ˇˇ", skip_hidden=false,locked=false})	--2
	add(achievements,{text="big\f8◆\fbben",hidden="ˇˇˇˇ",skip_hidden=false, locked=true})	--3

	add(achievements,{text="\f8◆\fbbonfire",locked=true,skip_hidden=true})		--4
	add(achievements,{text="low voltage\f8◆\fb",hidden="ˇˇˇˇˇˇ", skip_hidden=false, locked=true})--5
	add(achievements,{text="\f8◆\fbhigh voltage",hidden="ˇˇˇˇˇˇ", locked=true,skip_hidden=false})--6
	add(achievements,{text="robot\f8◆\fbdance",hidden="ˇˇˇˇˇˇ", locked=true,skip_hidden=false})--7
	add(achievements,{text="\f8◆\fbecholocation",hidden="ˇˇˇˇˇˇˇ", locked=true,skip_hidden=false})--8
	add(achievements,{text="yule\f8◆\fblog tender",hidden="ˇˇˇˇˇˇˇˇ", locked=true,skip_hidden=false})--9
	add(achievements,{text="x-ray vision\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇ", locked=true,skip_hidden=false})--10
	add(achievements,{text="\f8◆\fbexploded "..tostr(exploded_bulbs).." bulbs",hidden="ˇˇˇˇˇˇˇˇˇˇ", locked=false,skip_hidden=false})--11
	add(achievements,{text="romantic\f8◆\fblighting\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇ", locked=true,skip_hidden=false})--12
	add(achievements,{text="longest\f8◆\fbstring "..tostr(longest_snek).." bulbs",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false,skip_hidden=false})--13
	add(achievements,{text="\f8◆\fbelectric candlelight\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=true,skip_hidden=false})--14

	if (star_connected)achievements[1].locked=false

	if (big_ben) achievements[3].locked=false
	if (bonfire) achievements[4].locked=false
	if (low_voltage) achievements[5].locked=false
	if (high_voltage) achievements[6].locked=false
	if (echolocator) achievements[8].locked=false
	if (fire_lit) achievements[9].locked=false
	local xray_vision=0
	if (xray_bear) xray_vision+=1
	if (xray_doll) xray_vision+=1
	if (xray_diamond) xray_vision+=1
	if (xray_shirt) xray_vision+=1
	if xray_vision >0 then
		achievements[10].text ..= tostr(xray_vision).."/4"
		achievements[10].locked=false
	end
	if (romantic) achievements[12].locked=false
	if left_candle_lit != right_candle_lit then
		achievements[14].text..="1/2"
		achievements[14].locked=false
	end
	if left_candle_lit and right_candle_lit then
		achievements[14].text..="2/2"
		achievements[14].locked=false
	end
	
	if winner and not conflagration and not fuses_blown then
		add(achievements,{text="deck the halls \f4⌂\fb ho, ho, ho!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	elseif fuses_blown then
		add(achievements,{text="shocking conclusion\f8◆\fboh, no!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	else	
		add(achievements,{text="smoke alarm sing along\f8◆\fbuh, oh!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	end	
	add(achievements,{text="\f4❎ replay\fb",hidden="ˇˇˇˇ", locked=false})
	for achievement in all(achievements) do

		achievement.length=print(achievement.text,0,-16)
		achievement.locked_length=print(achievement.hidden,0,-16)
	end
end
function draw_achievements()
	color(green)
	local row=0
	for achievement in all(achievements) do
		if not achievement.locked then
			print(achievement.text,63-achievement.length\2,row)
		else
			if not achievement.skip_hidden then
				print(achievement.hidden,63-achievement.locked_length\2,row)
			else	
				row=row-8
			end	
		end	
		row=row+ 8		
	end
end	
function draw_intro()
	
	print("it's after midnight, but ",8,5,mid_blue)
	print("you're not lazy like that ",8,12,mid_blue)
	print("other elf who sits around ",8,19,mid_blue)
	print("spying on kids. you used to ",8,26,mid_blue)
	print("pull double shifts at the ",8,33,mid_blue)
	print("cobbler's after all. ",8,40,mid_blue)
	print("the jolly old elf said "..chr(34).."shh,",8,50,mid_blue)
	print("be quiet. string some lights," ,8,57,mid_blue)
	print("plug them in and connect ",8,64,mid_blue)
	print("the finial atop the tree."..chr(34),8,71,mid_blue)
	print("too bad you didn't finished ",8,81,mid_blue)
	print("your electrician's course...",8,88,mid_blue)
	print("⬅️➡️⬆️⬇️ TO MOVE ",8,99,mid_blue)
	print("❎ CONNECT/DISCONNECT OUTLET",8,105,mid_blue)
	print("🅾️ CONNECT/DISCONNECT FINIAL",8,111,mid_blue)
	print("❎ START",94,120,mid_blue)
end
function _draw()
	if intro then
		cls(0)
		pal(intro_palette,0)
		map(16,0)	--house
		map(0,0,0,0,15,15,5) --tree, unlit candles
		map(0,0,0,0,15,15,4) --star
		draw_intro()
		return
	end	
	if (not outro)	then
		if (#xray>0 and frame%3 >0 ) then
			rectfill(xray[1].x0,xray[1].y0,xray[1].x1,xray[1].y1,black)
			spr(xray[1].s,xray[1].x,xray[1].y,xray[1].w,xray[1].h)
		elseif (clockface and frame%2 >0 )	then
			circfill(92,51,2,blue)
			pset(92,50,charcoal)
			pset(92,51,charcoal)
			pset(93,51,charcoal)

		else
			cls(0)		
			if (not (gameover and fuses_blown)) then
				if not plugged_in then  --Dark Mode
					pal(dark_palette,0)
					map(16,0)	--house
					
					pal(dark_blue,black)
					pal(blue,charcoal)
					
					map(0,0,0,0,15,15,5) --tree, unlit candles
					pal(light_palette)
					pal(charcoal,black)
					pal(brown,charcoal)
					map(0,0,0,0,15,15,128)  -- lit candle lit fire

					if (star_connected and not plugged_in) then
						pal(star.palettes[2])
						map(0,0,0,0,15,15,4) --star

					end	
					if conflagration then
						
						pal(rnd(fire.palettes))
						map(48,0,0,0,14,14,2) --fire 
						pal(dark_blue,charcoal)
						pal(blue,charcoal)
						palt(dark_green,true)
						palt(green,true)
						map(64,0) --ashes
						palt()
						pal(dark_palette)
					end	
					pal(dark_blue,dark_blue)
					pal(blue,blue)
					
					
					pal(light_palette)
					
					pal(charcoal,black)
					pal(brown,charcoal)
					--map(0,0,0,0,15,15,128)
					
					pal(dark_palette)
					map(32,0) --gifts
					pal(gray,dark_blue)
					spr(robot.s[robot.index],robot.x,robot.y,1,2)
				else   -- Light Mode
					pal(light_palette)
					map(16,0)
					pal(dark_blue,dark_green)
					pal(blue,green)
					map(0,0)
					if (plugged_in and star_connected) then
						pal(star.palettes[star.index])
					
						map(0,0,0,0,15,15,4) --star
					end
					pal(light_palette)	
					
					if (fuses_blown) then
						
						pal(gray,black)
						print("OH",10,18,lavender)
						print("NO",23,18,lavender)
						
					end	
					
					if conflagration then
						pal(rnd(fire.palettes))
						map(48,0,0,0,14,14,2) --fire 
						pal(dark_blue,charcoal)
						pal(blue,charcoal)
						palt(dark_green,true)
						palt(green,true)
						map(64,0) --ashes
						palt()
						pal(light_palette)
					end	
					map(32,0)  --toys
					if conflagration and not fuses_blown then
						print("UH",10,18,lavender)
						print("OH",23,18,lavender)
					end
					if winner then
						print("❎achievements",70,117,charcoal)
						if (not conflagration) then
							print("HO",10,18,lavender)
							print("HO",23,18,lavender)	
							print("HO",10,34,lavender)	
						end	
					end
					if winner then
						spr(robot.s[1],robot.x,robot.y)
						spr(robot.s[2],robot.x,robot.y+8)
						if move_gifts then
							spr(204,robot.x+8,robot.y-10,2,3)
							spr(222,robot.x+24,robot.y-2,1,2)
							spr(239,robot.x+32,robot.y+6,2,2)
							spr(253,robot.x+16,robot.y+14,2,1)

						end
					else
						spr(robot.s[robot.index],robot.x,robot.y,1,2)
					end	
				end	
				pal(light_palette)
				palt(black,true)
				if (not winner) draw_bulbs()
				
				draw_snek()
			else	
				print("❎ achievements",32,60,charcoal)
			end	
		end	
	else  --outro achievements
		cls(0)
		draw_achievements()
	end	
end
function get_empty_cell()
	local gridx=flr(rnd(19)+1)
	local gridy=flr(rnd(19)+1)
	local snekx=flr(snek[1].x/6)
	local sneky=flr(snek[1].y/6)
	if ((snek_zone(gridx,gridy))) then
			return (false)
	else		
		return {x=gridx,y=gridy}
	end
	
end
function snek_zone(x,y)
	local gridx0, gridy0, gridx1, gridy1
	for bulb in all(snek) do
		gridx0=flr((bulb.x)/6)
		gridy0=flr((bulb.y)/6)
		gridx1=flr((bulb.x+6)/6)
		gridy1=flr((bulb.y+6)/6)
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
	gridx0=flr((snek[1].x-4)/6)
	gridy0=flr((snek[1].y-4)/6)
	gridx1=flr((snek[1].x+12)/6)
	gridy1=flr((snek[1].y+12)/6)
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
77777777f777fff7f777fff7f777fff7f777fff7f777fff766666666666666666666666644444444444444454444444444444444444444444444444444444444
777777777777ffff7777ffff7777ffff7777ffff7777ffff66666666666666666666666644444444444445454444444444444444454444444444444444444444
77777777f7f7f7ffcccccccccccccccccccccccccccccccc66666666666666666666666644444444444444454444444444444444444444444444444444444444
777777777777ffffcccccccccccccccccccccccccccccccc66666666666666666666666655555555555555555555555555555555555555555555555555555555
77777777f777fff7cccccccccccccccccccccccccccccccc60000000000000000000000044444445444444444444444444444444444444444444444444444445
777777777777ffff111111111111c1111c111111111111cc755555556ddddddd6555555544444545444444444444444445444444444444444444444444444545
77777777f7f7f7ff111111111111c1111c111111111111ccf55555556ddddddd6555555544444445444444444444444444444444444444444444444444444445
777777777777ffff111111111111c1111c111111111111cc76666666666666666666666644444445444444444444444444444444444444444444444444444445
f777fff7f777ffcc111111111111c1111c111111111111cc666666665556ddddddd6555700000000000000a90522500005335000059950000588500050050050
7777ffff7777ffcc111111111111c1111c111111111111cc666666665556ddddddd6555f90a0000090900a9a52cc250053bb350059aa950058ee850055550055
f7f7f7ccf7f7f7cc111111111111c1111c111111111111cc666666665556ddddddd6555f99a00a009000aa9a2ca7c2003baab3009a77a9008ef7e80050050050
7777ffcc7777ffcc111111111111c1111c111111111111cc66666666666666666666666f9aa90900a900aa9a2c7ac2003baab3009a77a9008e7fe80050050050
f777ffccf777ffcc111111111111c1111c111111111111cc000000066ddddddd655555579aa9000aaa90aa9a52cc250053bb350059aa950058ee850050059050
7777ffcc7777ffcc111111111111c1111c111111111111cc6555555f6ddddddd6555555f9aa9000aa9400a9a0522500005335000059950000588500050099550
f7f7f7ccf7f7f7cc111111111111c1111c111111111111cc6555555f6ddddddd6555555f99a9009aa9000a4900000000000000000000000000000000509aa950
7777ffcc7777ffcc111111111111c1111c111111111111cc6666666f666666666666666f9490009aa9000004000000000000000000000000000000005aa77aa5
ff444ff7f777fff7111111111111c1111c111111111111ccf5556dddddd655555556ddd749000009900009000022000000330000004400000088000050050050
744444ff7777ffff111111111111c1111c111111111111cc75556dddddd655555556dddf0009000090009a090222200003333000049940000888800055550055
f40404fff7f7f7ff111111111111c1111c111111111111ccf5556dddddd655555556dddf009a09009009aa00227c2200337b3300497a940088fe880050050050
744044ff7777ffff111111111111c1111c111111111111cc76666666666666666666666f909a40000009a90022cc220033bb330049aa940088e8880050050050
f44444f7f777fff7ccccccccccccccccccccccccccccccccfddddddd655555556dddddd7909a90909009a90a0222200003333000049940000888800050090050
740404ffcc77ffff111111111111c1111c111111111111cc7ddddddd655555556ddddddf009a900a0009a90a0022000000330000004400000088000050099550
f44044ffc7f7f7ff111111111111c1111c111111111111ccfddddddd655555556ddddddf0099909a9090900a0000000000000000000000000000000050a9aa50
77444fff7777ffff111111111111c1111c111111111111cc76666666666666666666666f00494000000000000000000000000000000000000000000059a77a95
f777fff7f777ffcc111111111111c1111c111111111111cc5556ddd7f777f6666667fff70d666d670d666d670200200000030000000000008000080050050050
7777ffff7777ffcc111111111111c1111c111111111111cc5556dddf7777f6666667ffff0d6d6d000d6d6d000000000003000000000404000008000055550055
f7f7f7fff7f7f7cc111111111111c1111c111111111111cc5556dddff7f7f6666667f7ff0d66d6670d66d667002c020000bb030004000000008e800050050050
7777ffff7777ffcccccccccccccccccccccccccccccccccc6666666f7777f6666667ffff0d666d000d666d0002cc0000303b000000099000808ee00050050050
f777fff7f777ffcccccccccccccccccccccccccccccccccc6dddddd7f777fff7f777fff700dd6000006dd0000000000000000300000940000008880050050050
7777f6667777cccccccccccccccccccccccccccccccccccc6ddddddf7777ffff7777ffff006d6700007760002002020000300000004000400800000050055550
f7f7f666f7f7fccccccccccccccccccccccccccccccccccc6ddddddff7f7f7fff7f7f7ff007700000000670000000000000000000000400000000000500aa050
7777f6667777fffccccccccccccccccccccccccccccccccc6666666f7777ffff7777ffff00000000000000000000000000000000000000000000000059a9a995
00000000000000000000577505770000000000000000000044444666666444445556ddddddd655555556dddd0022000000330000004400000088000066666666
00000000000000000000575777570000000000000000000044444666666444445556ddddddd655555556dddd0222200003333000044440000888800066666666
00000000000000000000057777750000000000b00000000044444666666444445556ddddddd655555556dddd22c2220033b333004494440088e8880066666666
00000000000000000000577070775000000000b00000000055554666666455550000000000000000000000002222220033333300444444008888880066666666
00000000000000000000577707775000000000b00000000044444440004444440050050050050050050050000222200003333000044440000888800066666666
000000000000000000000577777500000000b0b00b00000044444444444444440050050050050050050050000022000000330000004400000088000066666666
000099000990000000000057775000000000b0c00b00000044444444444444440050050050050050050050000000000000000000000000000000000066666666
000094999490000000000000750000000000b0c0b000000044444444444444440550055550055550055550000000000000000000000000000000000066666666
0000499999400000000007577757000000000bcb0000000066666666666666660050050050050050050050000022000000330000004400000088000066666666
00009919199000000000000575000000000000c10000000066666666666666660055550055550055550050000222200003333000044440000888800066666666
00009974799000000057757777757750000b00c10000000066666666666666660050050050050050050055502222220033333300444444008888880066666666
000009979900000000057005750075000000b0c10b0bb00066666666666666660050050050050050050050005222250053333500544445005888850066666666
000004999400000000005007770050000000b0c1bbb0000000000000000000000050050050050050050050000522500005335000054450000588500000000000
00008844488000000000000575000000000c3bccbb0000004dddddd65555555605500555500555500555500000550000005500000055000000550000ddddddd4
00088888888800000000005757500000bbbc11cc1cc000b04dddddd65555555600500000500500500500500000000000000000000000000000000000ddddddd4
049888888888940000000577577500000030b01c30bcc30046666666666666660055504400000005444500000000000000000000000000000000000066666664
0998888888889900f77444f7000000000003103c1bb0b0000000000055575550005004554455544454545050f5556ddd5556ddd7f777fff766666666f777fff7
09908888888099007744444f00000000000001cc11b3b000000000005555555000504544554445555544500075556ddd5556dddf7777ffff666666667777ffff
0000488888400000f740404f000000000000b3bc0bcc00000000000055757550005004554455544444550000f5556ddd5556dddff7f7f7ff66666666f7f7f7ff
00009900099000007744044f00000000000b00b1b0000b000000000055555550000000000000000000000000766666666666666f7777ffff666666667777ffff
0000999099900000f74444470000000000bccccc1cccc0000000000057757750000066666666666666666000fddddddd6dddddd7f777fff700000000f777fff7
00005990995000007740404f00000bbb0003b33cc330000000000000555755500006600000000000000066006ddddddd6dddddd66667ffffddddddd67777f666
0000000000000000f744044f00000000c10bbbb0c3b0b0000b000000775557700000000000000000000000006ddddddd6dddddd66667f7ffddddddd6f7f7f666
0000000000000000777444ff000000b0001cc1bccb3b3b3b0b0000005577755055555555555555555555555565555555555555566667ffff666666667777f666
000000000000000000000000000000ccc00bb3c11ccc3c1cb00000b000000000f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7ddd65555
000000000000000005505500000000001bb33bbccb3cc3bbbbbb0300000000007777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffffddd65555
000000000000000057757750000000b0011cc1c1cbb33b3bb1c3b0000000000044444444444444444444444444444444444444444444444444444444ddd65555
0000000000000000777777750000000bbbbb3bb1cc1c1b3bc33b0000000000004666676f54ba5aba5b4dd331343d43535434535030443d555115505466666666
00000000000000007777777500000000011ccbb1cbbbb1c111b000000000000046766766ad45a545a56bd5553455b504b54d503513343a151305d35465555555
000044400000000057777750000000bbbbb3b0c1cbbb3b3b3b00000000000000476676765aba56abd56a315a35344d354355b503055a1d55550a515465555555
0004444400000000057775000bbb00bbb3bb3bb1c11cccc330000000000000004676767664d56b55da3d5535535355430534551055b41500011d505465555555
0044fff44000000000575000000bbb0b3bb3b1bccbbb333cc0000bbb00000000453dd65a6b9d955a3d55d6d350444534355d535355505056050a551455555555
004f4f4f40000000000000000bbbbb1bb33b0b1c1b3113b00b0bbb00000000004653d3d65ddbd6bd6d66bdd6d4955555453435551350510f0155615400070000
004fffff40000000000500000bbb11111111b3b1111b3bbb03bb3b30000050004f7fffff763565dfff6fdffff67665666d5d55d555f5010d5511455400060000
004ff8ff4040000000888000000bb03bb33311111311111001c111b0000888004d66d6366d6d6666666dd666dd65636665f5f5d6455dfd053550f35400666000
4040fff00400000000888000000000111bb33bb1c330b3111b0bb000000888004dd66766666666666d646653665665d46ad65a5d546dddd65d5545d40666c600
04000f00000000000088800000000333b111111ccbbbb3333000b000000888004add6cdcd6d6dd6d66666ddd6da54df55ad5ad565a65d0045565d5f406666600
00088f8800f000000088800000bbbbb33b133bbc1111111c33b00000000888004dd66f666666d6d66d65fad5a6d55ada6d56d56ad6a51051d5ddf5d406666c00
00f88888ff00000004444400003b03bb01bb3bb113b13bbb33b0000000444440466d65666666666abfad6556dad456da5a3eddad5ad305006d4556a40d666d00
00f0888000000000444449900bbbbb3113333ccccbbbbbbb00b0000b044449994d666566c6663addf5da63adada546d5315d5534d35d0105dadf1654000d0000
000ff880000000000000000000bb11113333c3b1c3bcccccccbb00b3000000004666646d6adad7da5dd5f5d3666fdad5d55adadad515101adddd5ad406666600
000888880000000000000000000bbbb333333331c3cbbbbbbccccb0000000000466663fb6566ddadf5545ddadda66ddad656ada5a515050d555d5da46d666d60
00888888800000000003b0000000b00bbb33bb3cccb0b33bb00bb30000bb000046666a56fda646d5d5dfb53a666fdadd55a55dad555d010addddd5546d666d70
0d8888888d000000000b00b000b0bbb113b11111c333bbbbbbbb0000bbb0000045666d47d95fa6ffda5d4a646fa6dda655da55da351d0551115353147d666d00
088ff5ff88000000000bbbb000bb0bbbb11bb33ccbbb33bb33bccc0b3b0000004dd664f7ad46666dd55f64adf7df664ada665555555515511515555400d0d000
0d55f5f55d0000000000b3bbb03bb331333bbb31c3bccccccccbbbcc3bb000004666cadfddd50ad46a6ada3476664dfd514555da65d51515115a6a6400706000
0000707000000000000030bbbcbb333b133333311ccc0b33000bbbbb3000000046d6654d5dd516a6a1d6ada5ad4f653d55ad55ada55d1d51511dadd400007000
0000101000000000000003bbb3ccc333b111133113c3bb3b0bb0bb33b00b0b3046cf6f4da6ad5f6b6d56ad5ad56a5ada55da11dad5dd55151515f44400000000
0000577777500000000000bb333b3cc11b3bb11113bc00bb0bbb3bbb00bb31bb4f65adadadad53af5d5fdada5a55a6a515555555d55151d51515555400070000
0005775757750000000000003333333b33333bbc133bccccc11b31cccccc1bb04adadbf6da65555dad55a6ada6a535ddd5555d555d51d51d1511531400060000
0007507570575000000000cc1111133333b3333113b3bbbb333cccb0033b330045b4ad96a355555f6415d303103055353555555531555d151551555400666000
0005757575750000000bb3333333c11c1cc33b31133b33333b33bb3b333b00004dadadad5511d511551555535015311535331313533515d11510553406c66600
000057575750000000bb0033bbb33b3333311111133333333bb003333b0000004a5a6da655551555555053050155353535555050350555115115555406666600
0000057575000000000bbbb1b3bb3b333311bb311b33333bbbb00b33333000b04a6da6a155555dd56d1555501053505053353535553551d1515151340c666600
00000057500000000000b3bb1b3333b1113b33311c333333ccccccb3b33bbb0046a5dd313535d45d635005005050530351553535355555d1511155540d666d00
00000005000000000000333b311333bbb3b3333c1bcb33ccbb3b03ccc0033000435dddd555554ddd55555050350355534b5555355535515d15505534000d0000
0009000000000000000000003331b3b333333331133c11bb3b3b00000000033045d5dddd554d4d5a155550550055555dd4d5dd55535051111115050406666600
000a0000000000000000000111c11111113303311b33330bbb3bbb0bbbb00000444444444444444444444444444444444444444444444444444444446d666d60
008880000000000000b00000b3333b33b311cc1ccbb3b0b3330bbbbb11110000f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff7d666d60
008880000000000000b03000b33b303333b3330c0b0000bb0bbb111100000bbb7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff0d666d70
00888000000000000bb3bb000b33bb00bb3bb3bccb3bbb11111c00b0bb0b0330f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff700d0d000
008880000000000000b33bb3bbbbb0b0bb33b331cccccc33333b33bbbbb030007777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff00607000
04444400000000000000cccbb0bb3bb0033333311bb0b3333bb3bbbbbb330000f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff00700000
4444499000bbbbb0bbbbbbb1100b3bbb0cccccb1cb3bb333333bcbb0330000bb7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff00000000
000000000033333bbbbb03333cccc1cccc00bbc1133b333111113bb0ccccb3bb30000000f777fff7f75444f7f777fff788888898888888800000900000070000
00000000000b0b3b33bbb111133bbbbbbb3bb03cc333331333b31ccc333b33b0000000007777ffff7547774f7777ffff88888898888888800000a00000060000
00000000000000b011111333033b3bb33b33bb0cc11111bbb3333bb333bbb00b00000000f7f7f7ff5477d774f7f7f7ff88888898888888800008880000666000
0000007000000003333333333bb333b3b333b0bcc033b11113b333bb3b3b0b00bbbb00007777ffff54775d747777ffff88888898888888800008880006c6c600
0000009000000bb33b0b333333333113333111111bb33333311111cc1c11b3b033300000f777fff754777774f777fff788888898888888800008880006666600
070700900000000000b3333b33311b1111133331cb3333333333bbbb3bbb111b3bbb00007777ffff544777447777ffff888888988888888000088800066c6600
00990a9a0000000000b3b3333b33b3b3333bb33ccbb33b3bbbbb33b3333b333003000000f7f7f7f54444444447f7f7ff8888889888888880004444400d666d00
0799a9990000000000000b00bb333b3333333331111c1cc33333333bb3333b333b0000007777f544444444444447ffff888889998888888004444999000d0000
000a9aaa000000000000000000033333b33b333ccbbbb0b111111113333333300000b00000000000000005555500000088889989988888800000000006666600
7999aa9a00b3333b00000b0033333b03b3333bbccbbbbb3b03333331111ccc33bbbb3bb00000000005555777775555009999989899999990000000006d666d60
000a9aaa00003b3b31111111cb331cc11111111113b3333bb300333bb0bb0000033b33000000000057777555057777508888898988888880000099006d666d60
0799a999000003b0b3333330111c333b3333b3311b33bbbb00b0b3bb0bbb0000333b00000000000075555750575575758889989898888849990999907d666d70
00990a9a000000003bb3bb3bbbbbbb3b33b3333113b33bbbbbbbb3bbbbb0b0bb3b00000000000000750057757757507588888898898884990999099000d0d000
0707009000000000bb3b0bbbbbb33333333b3bb113b0bbcc1cc1c3bbb333bb33333000b007070000750057500775007588888898888884990999099000606000
0000009000bb000000b3b00b33bbb333333333b1111ccc3bb333bccc1ccccb00b33bbb0009900000750005070750007588888898888884990999099000707000
0000099900b3bb0000bbbbbbbb3bbb333b3333311333b33bb3333333b3bb3000b0033000a9970000750000057500007588888898844444999999990000000000
000000000bb333b0bbbbbb3b3bb333333bbbb331133bbb3bb30333333bb3bb00000000000bb00000750000570000057588888898848888899998888888000000
00000000000b33bbbbb00033b0b3333300bb00bc13bbbbbbb33b33b333b0bb00000bbbb330000000750005750000577588888898848888888998888888000000
00000000000003333bb333bb000b3b0b000bbbb1cb00bbb333bb3333333bbbbb03bb3b3300000000750057500055757588888898848888888998888888000000
000000000000b3333bb333333333bbbbb3bb30bc1bbb3333333333333333bbbb333bbb0000000000750577500577507588888898848888888998888888000000
00000000000b3bb3333333333b3bbbbb3333333c1bbbbbbbb333333bbb33bbb33333000000000000755700755755007588888898849999999999999999000000
0000000000bbbb3bb3333b33b33bbb333333303ccbbb0bb33bb333333bb3bbbbb300000000000000750570077500007588888898849999999999999999000000
00bbbb3bbb3bbbbb33bb33333bb111111111111113bb3bb3333b3333bb3bbbbbbb0bbbbbbbb00000750057755000007588888898808888888998888888000000
00003333b1111ccc33333b333b1b333b33b3333c111111111111111c333b11c33bb0bbb3bb000000750005500000007500000000008888888998888888000000
0000b00bb3b3333b111111c1113333333b333bb11333b3333333b331111133b3bbb30000b000000075000007000005759a000000008888888998888888000000
0000000b3303333b33333333333b3b03333b333113333bb3b000b0b033333bb33bbbb300000000007500000500000575a9997000008888888998888888000000
0000000b0000b0bbb3333330b3033033330033311333333000000303bb3b30bbbbbbbbb00000000057500000000057509a000000000000000000000000000000
0000000000000000b033b000000bb3b300000331c00b00000000003003b0b300b33b0b00000000000575000700057500a9970000000000000000000000000000
00000000000000000bb300000000bb3300000331c0000000000000300003000000b3000000000000005755555557500009900000000000000000000000000000
00000000000000000000000000000b0b00000031c0000000000000b0000300000000b00000000000000577777775000007070000000000000000000000000000
0000000000000000000000000000b00000000031c00000000000000b000000000000000000000000000055555550000000000000000000000000000000000000
__label__
f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7
7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff
7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7
7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff
7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7
7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f7f7f7ccccccccccccccccccccccccccccccccccccccccccf7f7f7fff7f7f7ff44444444444444444444444444444444444444444444444444444444f7f7f7ff
7777ffcccccccccccccccccccccccccccccccc7ccccccccc7777ffff7777ffff4666676f54ba5aba5b4dd331343d43535434535030443d55511550547777ffff
f777ffcccccccccccccccccccccccccccccccc9cccccccccf777fff7f777fff746764466ad45a545a56bd5553455b504b54d503513343a151305d354f777fff7
7777ffcc111111111111c1111111111117171191171711cc7777ffff7777ffff476499465aba56abd56a315a35344d354355b503055a1d55550a51547777ffff
f7f7f7cc111111111111c111111111111c991a9a199111ccf7f7f7fff7f7f7ff46497a9464d56b55da3d5535535355430534551055b41500011d5054f7f7f7ff
7777ffcc111111111111c111111111111799a999a99711cc7777ffff7777ffff4549aa946b9d955a3d55d6d350444534355d535355505056050a55147777ffff
f777ffcc111111111111c111111111111c1a9aaa9a1111ccf777fff7f777fff7465499465ddbd6bd6d66bdd6d4955555453435551350510f01556154f777fff7
7777ffcc111111111111c111111111117999aa9aa99971cc7777ffff7777ffff4f7f44ff763565dfff6fdffff67665666d5d55d555f5010d551145547777ffff
f7f7f7cc111111111111c111111111111c1a9aaa9a1111ccf7f7f7fff7f7f7ff4d66d6366d6d6666666dd666dd65636665f5f5d6455dfd053550f354f7f7f7ff
7777ffcc111111111111c111111111111799a999a99711cc7777ffff7777ffff4dd66766666666666d646653665665d46ad65a5d546dddd65d5545d47777ffff
f777ffcc111111111111c111111111111c991a9a199111ccf777fff7f777fff74add6cdcd6d6dd6d66666ddd6da54df55ad5ad565a65d0045565d5f4f777fff7
7777ffcc111111111111c1111111111117171191171711cc7777ffff7777ffff4dd66f666666d6d66d65fad5a6d55ada6d56d56ad6a51051d5ddf5d47777ffff
f7f7f7cc111111111111c111111111111c111191111111ccf7f7f7fff7f7f7ff466d65666666666abfad6556dad456da5a3eddad5ad305006d4556a4f7f7f7ff
7777ffcc111111111111c111111111111c111999111111cc7777ffff7777ffff4d666566c6663addf5da63adada546d5315d5534d35d0105dadf16547777ffff
f777ffcc111111111111c111111111111c111bbb111111ccf777fff7f777fff74666646d6adad7da5dd5f5d3666fdad5d55adadad515101adddd5ad4f777fff7
7777ffcc111111111111c111111111111c1111b3111111cc7777ffff7777ffff466663fb6566ddadf5545ddadda66ddad656ada5a515050d555d5da47777ffff
f7f7f7cc111111111111c111111111111c1b11b3111111ccf7f7f7fff7f7f7ff46666a56fda646d5d5dfb53a666fdadd55a55dad555d010addddd554f7f7f7ff
7777ffcc111111111111c111111111111c11b1b31b1bb1cc7777ffff7777ffff45666d47d95fa6ffda5d4a646fa6dda655da55da351d0551115353147777ffff
f777ffccccccccccccccccccccccccccccccbcb3bbbcccccf777fff7f777fff74dd664f7ad46666dd55f64adf7df664ada6655555555155115155554f777fff7
7777ffcc111111111111c111111111111c1b3bbbbb1111cc7777ffff7777ffff4666cadfddd50ad46a6ada3476664dfd514555da65d51515115a6a647777ffff
f7f7f7cc111111111111881111111111bbbb33bb3bb111bcf744f7fff7f7f7ff46d6654d5dd516a6a1d6ada5ad4f653d55ad55ada55d1d51511dadd4f7f7f7ff
7777ffcc1111111111188881111111111c31b13b31bbb3cc74994fff7777ffff46cf6f4da6ad5f6b6d56ad5ad56a5ada55da11dad5dd55151515f4447777ffff
f777ffcc111111111188fe88111111111c13313b3bb1b1cc497a94f7f777fff74f65adadadad53af5d5fdada5a55a6a515555555d55151d515155554f777fff7
7777ffcc111111111188e888111111111c1113bb33b3b1cc49aa94ff7777ffff4adadbf6da65555dad55a6ada6a535ddd5555d555d51d51d151153147777ffff
f7f7f7cc1111111111188881111111111c11b3bb1bbb11ccf49947fff7f7f7ff45b4ad96a355555f6415d303103055353555555531555d1515515554f7f7f7ff
7777ffcc1111111111118811111111111c1b11b3b1111bcc7744ffff7777ffff4dadadad5511d511551555535015311535331313533515d1151055347777ffff
f777ffcc111111111111c111111111111cbbbbbb3bbbb1ccf777fff7f777fff74a5a6da6555515555550530501553535355550503505551151155554f777fff7
7777ffcc111111111111c11111111bbb1c13b33bb33111cc7777ffff7777ffff4a6da6a155555dd56d1555501053505053353535553551d1515151347777ffff
f7f7f7cc111111111111c11111111111b31bbbb1b3b1b1ccfbf7f7fff7f7f7ff46a5dd313535d45d635005005050530351553535355555d151115554f7f7f7ff
7777ffcc111111111111c111111111b11c3bb3bbbb3b3b3b7b77ffff7777ffff435dddd555554ddd55555050350355534b5555355535515d155055347777ffff
f777ffcc111111111111c111111111bbbc1bb3b33bbb3b3bb777ffb7f777fff745d5dddd554d4d5a155550550055555dd4d5dd555350511111150504f777fff7
7777ffcc111111111111c111111111113bb33bbbbb3bb3bbbbbbf3ff7777ffff444444444444444444444444444444444444444444444444444444447777ffff
f7f7f7cc111111111111c111111111b1133bb3b3bbb33b3bb3b3b7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff
7777ffcc111111111111c1111111111bbbbb3bb3bb3b3b3bb33bffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f777ffccccccccccccccccccccccccccc33bbbb3bbbbb3b333b7fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7
7777ffcc111144411111c111111111bbbbb3b1b3bbbb3b3b3b77ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f7f7f7cc111444441111c1111bbb11bbb3bb3bb3b33bbbb337f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff
7777ffcc1144fff44111c111111bbb1b3bb3b3bbbbbb333bb777fbbb7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff
f777ffcc114f4f4f4111c1111bbbbb3bb33b1b3b3b3333bcfb7bbbf7f777fff7f777fff7f777fff7f777fff7f75444f7f777fff7f777fff7f777fff7f777fff7
7777ffcc114fffff4111c1111bbb33333333b3b3333b3bbb73bb3b3f7777ffff7775ffff7777ffff7777ffff7547774f7777ffff7777ffff77775fff7777ffff
f7f7f7cc114ff8ff4141c111111bb13bb33333333333333cf3b333bff7f7f7fff78887fff7f7f7fff7f7f7ff5477d774f7f7f7fff7f7f7fff7f888fff7f7f7ff
7777ffcc4141fff11411c111111111333bb33bb3b331b3333b7bbfff7777ffff77888fff7777ffff7777ffff54775d747777ffff7777ffff777888ff7777ffff
f777ffcc14111f111111c11111111333b333333bbbbbb3333777bff7f777fff7f7888ff7f777fff7f777fff754777774f777fff7f777fff7f77888f7f777fff7
7777ffcc11188f8811f1c11111bbbbb33b333bbb3333333b33b7ffff7777ffff77888fff7777ffff7777ffff544777447777ffff7777ffff777888ff7777ffff
f7f7f7cc11f88888ff11c111113b13bb13bb3bb333b33bbb33b7f7fff7f7f7fff44444fff7f7f7fff7f7f7f54444444447f7f7fff7f7f7fff744444ff7f7f7ff
7777ffcc11f188811111c1111bbbbb3333333bbbbbbbbbbb77b7fffb7777ffff4444499f7777ffff7777f544444444444447ffff7777ffff744449997777ffff
f777ffcc111ff8811111c11111bb33333333b3b3b3bbbbbbbbbbffb3f777f666666666666666666666666666666666666666666666666666666666666667fff7
7777ffcc111888881111c111111bbbb333333333b3bbbbbbbbbbbbff7777f666666666666666666666666666666666666666666666666666666666666667ffff
f7f7f7cc118888888113b1111111b11bbb33bb3bbbb1b33bb7fbb3fff7bbf666666666666666666666666666666666666666666666666666666666666667f7ff
7777ffcccd8888888dcbccbcccbcbbb333b33333b333bbbbbbbbffffbbb7f666666666666666666666666666666666666666666666666666666666666667ffff
f777ffccss8ff5ff88cbbbbcccbbcbbbb33bb33bbbbb33bb33bbbbfb3b77fff760000000000000000000000000000000000000000000000000000006f777fff7
7777cccssss5f5f55dccb3bbbc3bb333333bbb33b3bbbbbbbbbbbbbb3bb7ffff755555556ddddddd655555556ddddddd655555556ddddddd6555555f7777ffff
f7f7fcss7css7c7ccccc3cbbbbbb333b333333333bbbcb33c7fbbbbb37f7f7fff55555556ddddddd655555556ddddddd655555556ddddddd6555555ff7f7f7ff
7777ffssccss1c1cccccc3bbb3bbb333b333333333b3bb3b7bb7bb33b77bfb3f7666666666666666666666666666666666666666666666666666666f7777ffff
f777fffssss7fff7f777ffbb333b3bb33b3bb33333bbffbbfbbb3bbbf7bb33bbf5556dddddd655555556ddddddd655555556ddddddd655555556ddd7f777fff7
7777ffffss77ffff7777ffff3333333b33333bbb333bbbbbb33b33bbbbbb3bbf75556dddddd655555556ddddddd655555556ddddddd655555556dddf7777ffff
f7f7f7fff7f7f7fff7f7f7bb3333333333b3333333b3bbbb333bbbbff33b33fff5556dddddd655555556ddddddd655555556ddddddd655555556dddff7f7f7ff
7777ffff7777ffff777bb3333333b33b3bb33b33333b33333b33bb3b333bffff7666666666666666666666666666666666666666666666666666666f7777ffff
f777fff7f777fff7f7bbff33bbb33b3333333333333333333bb7f3333b77fff7fddddddd655555556ddddddd655555556ddddddd655555556dddddd7f777fff7
7777ffff7777ffff777bbbb3b3bb3b333333bb333b33333bbbb7fb333337ffbf7ddddddd655555556ddddddd655555556ddddddd655555556ddddddf7777ffff
f7f7f7fff7f7f7fff7f7b3bb3b3333b3333b33333b333333bbbbbbb3b33bbbfffddddddd655555556ddddddd655555556ddddddd655555556ddddddff7f7f7ff
7777ffff7777ffff7777333b333333bbb3b3333b3bbb33bbbb3bf3bbb7733fff7666666666666666666666666666666666666666666666666666666f7777ffff
f777fff7f777fff7f777fff73333b3b333333333333b33bb3b3bfff7f777f337f5556dddddd655555556ddddddd655555556ddddddd655555556ddd7f777fff7
7777ffff7777ffff7777fff333b333333333f3333b3333fbbb3bbbfbbbb7ffff75556dddddd655555556ddddddd655555556ddddddd655555556dddf7777ffff
f7f7f7fff7f7f7fff7b7f7ffb3333b33b333bb3bbbb3b7b333fbbbbb3333f7fff5556dddddd655555556ddddddd655555556ddddddd655555556dddff7f7f7ff
7777ffff7777ffff77b73fffb33b3f3333b333fb7b77ffbb7bbb33337777fbbb7666666666666666000000000000000000000000666666666666666f7777ffff
f777fff7f777fff7fbb3bbf7fb33bbf7bb3bb3bbbb3bbb33333bffb7bb7bf337fddddddd65555555005005005005005005005000655555556dddddd7f777fff7
7777ffff7777ffff77b33bb3bbbbbfbfbb33b333bbbbbb33333b33bbbbb73fff7ddddddd65555555005005005005005005005000655555556ddddddf7777ffff
f7f7f7fff7f7f7fff7f7bbbbb7bb3bbff33333333bb7b3333bb3bbbbbb33f7fffddddddd65555555005005005005005005005000655555556ddddddff7f7f7ff
7777ffff77bbbbbfbbbbbbb3377b3bbb7bbbbbb3bb3bb333333bbbbf3377ffbb7666666666666666055005555005555005555000666666666666666f7777ffff
f77444f7f733333bbbbbf3333bbbb3bbbb77bbb3333b333333333bb7bbbbb3bb35556dddddd65555005005005005005005005000ddd655555556ddd7ff444ff7
7744444f777bfb3b33bbb333333bbbbbbb3bbf3bb333333333b33bbb333b33bf75556dddddd65555005555005555005555005000ddd655555556dddf744444ff
f740404ff7f7f7bf33333333f33b3bb33b33bbfbb33333bbb3333bb333bbb7fbf5556dddddd65555005005005005005005005550ddd655555556dddff40404ff
7744044f7777fff3333333333bb333b3b333bfbbb733b33333b333bb3b3bfbffbbbb666666666666005005005005005005005000666666666666666f745335ff
f7444447f777fbb33b7b333333333333333333333bb33333333333bb3b33b3b7333ddddd65555555005005005005005005005000655555556dddddd7f53bb357
7740404f7777ffff77b3333b33333b3333333333bb3333333333bbbb3bbb333b3bbbdddd65555555055005555005555005555000655555556ddddddf73baab3f
f744044ff7f7f7fff7b3b3333b33b3b3333bb33bbbb33b3bbbbb33b3333b333ff3dddddd6555555500500000500500500500500065559955699ddddff3baab3f
777444ff7777ffff7777fbffbb333b3333333333333b3bb33333333bb3333b333b66666666666666005550440000000544450000666694999496666f753bb35f
f777fff7f777fff7f777fff7f7733333b33b333b888888988888888333333337f555bdddddd65555005004554455544454545050ddd649999946ddd7f75335f7
7777ffff77b3333b7777fbff33333bf3b3333bbb8888889888888883333bbb33bbbb3bbdddd65555005045445544455555445000ddd699191996dddf7775995f
f7f7f7fff7f73b3b33333333bb333bb333333333888888988888888bb7bbf7fff33b33ddddd65555005004554455544444550000ddd699747996dddff759aa95
7777ffff7777f3bfb333333f333b333b3333b333888888988888888b7bbbffff333b666666666666000000000000000000000000666669979966666f779a77a9
f777fff7f777fff73bb3bb3bbbbbbb3b33b33333888888988888888bbbb7bfbb3bdddddd655555550000666666666666666660006555549994ddddd7f79a77a9
7777ffff7777ffffbb3bfbbbbbb33333333b3bb3888888988888888bb333bb33333dddbd6555555500066000000000000000660065558844488dddd66659aa95
f7f7f7fff7bbf7fff7b3b7fb33bbb333333333b3888888988888888b3bbbbb66b33bbbdd65555555000000000000000000000000655888888888ddd66665995f
7777ffff77b3bbff77bbbbbbbb3bbb333b3333338888899988888883b3bb3666b55335555555555555555555555555555555555554988888888894566665ffff
444444444bb333b4bbbbbb3b3bb333333bbbb33388889989988888833bb3bb66666666666bb6666666666666666666666666666669988888888899665ss54444
44444444444b33bbbbb44533b4b3333344bb44bb999998989999999333b4bb66666bbbb3366666666666666666666666666666666996888888869965sccs5444
44444444444443333bb333bb444b3b4b444bbbb38888898988888883333b99bb63bb3b3366666666666666666666666666666666666648888846666sca7cs444
555555555555b3333bb333333333bbbbb3bb35bb88899898988888499939999b333bbb6666666666666666666666666666666666666699666996666sc7acs555
44444444444b3bb3333333333b3bbbbb3333333b8888889889888499b999b99333330000000000000000000000000000000000000000999099900005sccs5444
4444444444bbbb3bb3333b33b33bbb333333343b88888898888884993999b99bb3ddddd655555556ddddddd655555556ddddddd655555996995d59955ss54444
44bbbb3bbb3bbbbb33bb33333bb33333333333338888889888888499b999b99bbbdbbbbbbbb55556ddddddd655555556ddddddd655555556ddd59aa954444444
44443333b3333bbb33333b333b3b333b33b3333b8888889884444499999999b33bb6bbb3bb666666666666666666666666666666666666666669a77a94444444
4444b44bb3b3333b333333b3333333333b333bb388888898848888899998888888b34444b4444444444444444444444444445ss5444444444449a77a94444444
4444444b3343333b33333333333b3b43333b333388888898848888888998888888bbb3444444444444444444444444444445sccs5444444444459aa954444444
4444444b4444b4bbb3333334b34334333344333388888898848888888998888888bbbbb4444444444444444444444444444sca7cs44444444444599544444444
5555555555555555b533b555555bb3b355555333888888988488888889988888883b5b55555555555555555555555555555sc7acs55555555995555555555555
44444445444444444bb344444444bb334444433388888898849999999999999999b344444444444444444445444444444445sccs544444459aa9544444444444
44444545454444444444444444444b4b444444338888889884999999999999999944b44444444444444445454544444444445ss555335449a77a944444444444
4444444544444444444444474444b44444444433888888988488888889988888884444444444444444444445444444444444444453bb3549a77a944444444444
444444454444444444444446444444444444444444444444448888888998888888444444444444444444444544444444444444443baab3559aa9544444444444
444444454444444444444466644444444444444444444444448888888998888888444444444444444444444544444444444444443baab3445995444444444444
4444454545444444444446c6c644444444444444444444444488888889988888884444444444444444444545454444444444444453bb35444444444444444444
44444445444444444444466666444444444444444444444444444444444444444444444444444444444444454444444444444444453354444444444444444444
55555555555555555555566c66555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
444444444444444444444d666d444444444444454444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444d44444444444445454544444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444466666444444444444454444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444446d666d644444444444454444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444446d666d644444444444454444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
444444444444444444447d666d744444444445454544444444444444444444444444444444444444444444444444444444444444444444444444444444444444
4444444444444444444444d4d4444444444444454444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555556565555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444447474444444444444444444444444444444444444444444444544444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444454545444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444544444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444544444444444444444444444444444444444444444444444444444444

__gff__
0000000000000000000000000000000000000000000000000002020000000080000000000000000000020200000000800000000000000000000000000000008000000000010100000000000000000000000000000101000000000000000000000000000101010000000000000000000000000001010101000000000000000000
0000010101010101000000000000000000000101010101010000000000000000000001010101010100000000000000008001010101010101000000000000000004010101010101010100000000008000040101010101010101040000000000000101010101010101010100000000000001010101010000000001000004000000
__map__
0000000000000000000000000000000001010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c0d900000000000000000000100203020405010178797a7b7c7d7e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d0fc00000000000000000000111213121415010188898a8b8c8d8e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000545500000000000000000000112223222425010198999a9b9c9d9e01000000000000000000000000000000000000000054550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000636465660000000000000000001112131214150101a8a9aaabacadae01000000000000000000000000000000000000006364656600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000737475760000000000000000001122232224250101b8b9babbbcbdbe01007071000000000000000000000000000000007374757600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000008384858600820000000000870011121312141501010101c9cacb010101008081000000000000000000000000000000008384858600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000929394959697000000000000000031323332343521370607080708071638009091000000000000000000000000000000929394959697000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000a2a3a4a5a6a7000000000000000001010101010101012627172717272801000000000000000000000000000000000000a2a3a4a5a6a7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b1b2b3b4b5b6b700000000000000000101010101010101262748494a2736010000000000000000000000000000000000b1b2b3b4b5b6b7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c1c2c3c4c5c6c7c80058595a000000620101010101010126270000002736200000000000000000000000000040410000c1c2c3c4c5c6c7c80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d1d2d3d4d5d6d7d80068696a00000001010101010101306b7f0000007f6c6d0000000000cccd00000000000050510000d1d2d3d4d5d6d7d80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e0e1e2e3e4e5e6e7e8e90000000000000e0e0a0e0e090c4656576e576e575f470000000000dcddde0000000000606100e0e1e2e3e4e5e6e7e8e900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f1f2f3f4f5f6f7f8f90000000000000f0c0e0e0e0a0d0e0e0e090c0e0e0e0e0000000000ecedeeef00000000000000f0f1f2f3f4f5f6f7f8f900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000a0d0e0e0f0c0e0e0e0e0a0d0e0e0e0e000000000000fdfeff000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e0e0e0e0a0d0e0e0f0c0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
d00f00002454224542245422454224542000002254200000215422154221542000001f5421f5421f542000001d5421d5421d542000001f5421f5421f54200000215422154221542000001d5421d5421d54200000
d00f00002154221542215422154221542000001f542000001d5421d5421d542000001c5421c5421c542000001a5421a5421a542000001c5421c5421c542000001d5421d5421d542000001a5421a5421a54200000
d00f00001854218542185421854218542000001854200000185421854218542000001654216542165420000015542155421554200000185421854218542000001854218542185420000015542155421554200000
d00f00001154211542115421154211542000001154200000115421154211542000000c5420c5420c542000000e5420e5420e542000000c5420c5420c542000001154211542115420000011542115421154200000
d00f00001f54200000215420000022542000001f542000002154221542215422154221542000001f542000001d5421d5421d542000001c5421c5421c542000001d5421d5421d5421d5421d5421d5421d54200000
d00f00001c542000001d552000001f552000001c542000001d5421d5421d5421d5421d542000001a5420000018542185421854200000185421854218542000001854218542185421854218542185421854200000
d00f00001854200000185420000018542000001854200000185421854218542185421854200000165420000015542155421554200000135421354213542000001554215542155421554215542155421554200000
d00f00000c542000000c542000000c542000000c542000001155211552115521155211552000000a542000000c5420c5420c542000000c5420c5420c542000001154211542115421154211542115421154200000
d00f00002455224552245522455224552000002254200000215422154221542000001f5421f5421f542000001d5421d5421d542000001f5421f5421f54200000215522155221552000001d5421d5421d54200000
d00f00002155221552215522155221552000001f542000001d5421d5421d542000001c5421c5421c542000001a5421a5421a542000001c5421c5421c542000001d5421d5421d5420000018542185421854200000
d00f00001855218552185521855218552000001854200000185421854218542000001654216542165420000015542155421554200000185521855218552000001854218542185420000015542155421554200000
d00f00001154211542115421154211542000001054200000115421154211542000000c5420c5420c542000000e5420e5420e542000000c5420c5420c542000001154211542115420000011542115421154200000
d00f00001f54200000215520000022552000001f542000002154221542215422154221542000001f542000001d5421d5421d542000001c5421c5421c542000001d5421d5421d5421d5421d5421d5421d54200000
d00f00001c542000001d552000001f542000001c542000001d5421d5421d5421d5421d542000001a5420000018542185421854200000185421854218542000001854218542185421854218542185421854200000
d00f00001855200000185420000018542000001854200000185421854218542185421854200000165420000015542155421554200000135421354213542000001554215542155421554215542155421554200000
d00f00000c542000000c542000000c542000000c542000001154211542115421154211542000000a542000000c5420c5420c542000000c5420c5420c542000001155211552115521155211552115521155200000
d00f00001f5421f5421f5421f5421f542000002154200000225422254222542000001f5421f5421f542000002154221542215422154221542000002254200000245422454224542000001f5421f5421f54200000
d00f00001c5521c5521c5521c5521c552000001d542000001f5521f5521f552000001c5421c5421c542000001d5421d5421d5421d5421d542000001d542000001d5421d5421d5420000018552185521855200000
d00f00001855218552185521855218552000001854200000185421854218542000001854218542185420000018542185421854218542185420000013542000001554215542155420000010542105421054200000
d00f00000c5420c5420c5420c5420c542000000c542000000c5420c5420c542000000c5420c5420c5420000011542115421154211542115420000011542000001154211542115420000000000000000000000000
d00f00002154200000235520000024542245422454200000265420000028542000002955229552295520000028542285422854200000265422654226542000002454224542245422454224542245422454200000
d00f00001d542000001d542000001c5421c5421c5420000021552000002154200000215422154221542000001f5421f5421f542000001d5421d5421d542000001c5421c5421c5421c5421c5421c5421c54200000
d00f00001854200000185420000018542185421854200000185420000018542000001854218542185420000018542185421854200000175421754217542000001855218552185521855218552185521855200000
d00f00001154200000115420000015542155421554200000115420000011542000000c5420c5420c5420000013552135521355200000135421354213542000000c5420c5420c5420c5420c5420c5420c54200000
d00f00002454224542245422454224542000002254200000215422154221542000001f5421f5421f542000001d5421d5421d542000001f5521f5521f55200000215422154221542000001d5421d5421d54200000
d00f00002155221552215522155221552000001f542000001d5421d5421d542000001c5421c5421c542000001a5421a5421a542000001c5521c5521c552000001d5521d5521d5520000018542185421854200000
d00f00001854218542185421854218542000001855200000185421854218542000001854218542185420000015542155421554200000185521855218552000001855218552185520000015542155421554200000
d00f00001154211542115421154211542000001054200000115421154211542000000c5420c5420c542000000e5420e5420e542000000c5420c5420c542000001155211552115520000011542115421154200000
d00f000026552000002654200000265420000026542000002454224542245422454224542000002254200000215422154221542000001f5421f5421f542000001d5421d5421d5421d5421d5421d5421d54200000
d00f00001d552000001d542000001d542000001d542000001d5521d5521d5521d5521d552000001f542000001d5421d5421d542000001c5421c5421c542000001554215542155421554215542155421554200000
d00f000016542000001654200000165420000016542000001854218542185421854218542000001a5420000018542185421854200000165421654216542000001155211552115521155211552115521155200000
d00f180000000000000000000000000000000000000000001554215542155421554215542000001654200000000000000000000000000c5420c5420c542000000140001400014000140001400014000140001400
450f00002b1402b1422b1421800030140180003014018000301403014230142180003215032152321521800034150180003414018000341403414234142341423414218000341401800032140180003414018000
450f0000351503515235152180002f1402f1422f14218000321403214232142180003014030142301421800018000180003714018000371401800034140180003914039142391423914239142180003714018000
450f00003714018000351401800035140351423514235142351421800035140180003514018000321401800037150371523715237152371521800035140180003514018000341401800034140341423414218000
450f00002b1502b1522b1521800030140180003014018000301403014230142180003214032142321421800034150180003414018000341403414234142341423414218000341401800032140180003414018000
450f1500351503515235152180002f1402f1422f14218000321503215232152180003014030142301423014230132301323012230115194001940019400194001940019400194001940019400194001940019400
000100003a0603a0503a0053f0653f0403f020305052a505361003650036505365053450029500295002f5003f500335003450029500295002f5003f500335003450029500295002f5003f500005000050000500
410101013f6733f6353f6743e60334604006053f6733f67500604016032e6043f6533f605016053f6233e6043f6033d6043860335605086030660503603026040c0040740400604083040c004172041160400404
413c19003415538155361552f1550000034155361553815534155000003815534155361552f155000002f15536155381553415500000000000000029105281000000028105000000000000000000000000000000
8d3c0f002817500000000000000000000281750000000000000000000028175000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00003b1503b1503b1503b1503b150000000000000000000003b1503b1503b1503b150000000000000000000003b1503b1503b1503b1503b15000000000000000000000000000000000000000000000000000
010500003c1503c1503c1503c1503c150000000000000000000003c1503c1503c1503c150000000000000000000003c1503c1503c1503c1503c15000000000000000000000000000000000000000000000000000
010f00003f1503f1503f1503f1503f150000000000000000000003f1503f1503f1503f1503f150000000000000000000003f1503f1503f1503f1503f150000000000000000000000000000000000000000000000
010f00000000000000000003f1503f1503f1503f1503f150000000000000000000003f1503f1503f1503f1503f150000000000000000000003f1503f1503f1503f1503f150000000000000000000000000000000
010f1c000000000000000000000000000000003f1503f1503f1503f1503f150000000000000000000003f1503f1503f1503f150000000000000000000003f1503f1503f1503f1503f15001400014000140001400
d40100032012025120201200000000000000000140001400014000140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010106003f67030050210501965010050086500100000000190000000000000140000000011000100000f00008600100001960021000300003f6000000008000080000a0000c0000d00000000000000000000000
0101000022060220503a005270652704027020305052a505361003650036505365053450029500295002f5003f500335003450029500295002f5003f500335003450029500295002f5003f500005000050000500
110f00001d57500500005001f5751d575005001a57500500005000050000500005001d57500500005001f5751d575005001a57500500005000050000500005001d57500500005001f5751d575005001a57500500
110f1c00005000050000500005001d57500500005001f5751d575005001a57500500005000050000500005001d57500500005001f5751d575005001a57500500005000050000500005001d57500500005001f575
010100002957518500185002b57529575185002657518500185001850018500185002957518500185002b57529575185002657518500185001850018500185002957518500185002b57529575185002657518500
010100000c5000c5000c5000c500295750c5000c5002b575295750c500265750c5000c5000c5000c5000c500295750c5000c5002b575295750c500265750c5000c5000c5000c5000c500295750c5000c5002b575
000500001d7611d7611d7611f7611d7611d7611a7611a7611a7611a7611a7611a7611d7611d7611d7611f7611d7611d7611a7611a7611a7611a7611a7611a7611d7611d7611d7611f7611d7611d7611a7611a761
000500001d7611d7611d7611f7611d7611d7611a7611a7611a7611a7611a7611a7611d7611d7611d7611f7611d7611d7611a7611a7611a7611a7611a7611a7611d7611d7611d7611f7611d7611d7611a7611a761
42010400136701d6502a6503a65010050086500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 00010203
00 04050607
00 08090a0b
00 0c0d0e0f
00 10111213
00 14151617
00 18191a1b
04 1c1d1e1f
00 20404040
00 21404040
00 22404040
00 23404040
04 24404040
00 27424344
04 28424344
00 2b404040
04 2c404040
04 2b404040
00 2c404040
04 2e404040
01 31404040
02 32404040
01 33404040
00 34404040
00 33404040
00 34424344
00 33424344
00 34424344
00 34424344
00 33424344
00 34424344
00 33424344
04 34424344