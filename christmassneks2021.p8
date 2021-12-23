pico-8 cartridge // http://www.pico-8.com
version 34
__lua__
--by jenny schmidt (bikibird)
--for christmas 2021

black,dark_blue,mid_blue,dark_green,brown,charcoal,gray,white,red,orange,yellow,green,blue,lavendar,pink,peach=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
left,right,up,down,fire1,fire2=0,1,2,3,4,5
becalmed=6
buttons={}
buttons[1]=left; buttons[2]=right; buttons[4]=up; buttons[8]=down
bulb_colors={green,red,blue,yellow}
bulb_blink={dark_green,pink,dark_blue,brown}
sparks={yellow,black,black,orange}
yule_set={31, 47,63}

detect_star = function(x,y)
	
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
	if plugged_in and x\8==11 and y\8==6 and stat(54)==0 then
		music(13)
		big_ben= true
		return true
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
									
										--detect_robot
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
function ho_ho_ho()
	winner=true
star_connected=true
	create_achievements()
	music(0)
end	
function uh_oh()
	winner=true
	star_connected=true
	create_achievements()		
	music(8)
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
			--{[orange]=orange, [yellow]=yellow, [white]=white},
			[0]={[orange]=yellow, [yellow]=white, [white]=orange},
			[1]={[orange]=white, [yellow]=orange, [white]=yellow},
			[2]={[orange]=orange, [yellow]=orange, [white]=orange}
		},
		index=2
	}
	fire=
	{
		palettes=
		{
			--{[orange]=orange, [yellow]=yellow, [white]=white},
			[0]={[orange]=orange, [yellow]=yellow},
			[1]={[orange]=yellow, [yellow]=orange},
			[2]={[orange]=brown, [yellow]=orange},
			[2]={[orange]=red, [yellow]=orange}
		},
		index=0
	}

	achievements={}

	pal({[0]=0,1,140,3,4,5,6,7,8,9,10,11,12,13,14,15},1)
	light_palette={[0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
	dark_palette={[0]=black,dark_blue,black,charcoal,dark_blue,black,charcoal,black,black,black,black,black,black,black,black,black}
	frame=0
	big_ben=false
	bonfire=false
	conflagration=false
	fire_lit=false
	fuses_blown=false
	gameover=false
	high_voltage=false
	plugged_in=false
	left_candle_lit=false
	low_voltage=false
	outro=false
	right_candle_lit=false
	romantic=false
	short=0
	star_connected=false
	winner=false
	xray_bear=false
	xray_diamond=false
	xray_doll=false
	xray_shirt=false
	
	init_snek_yard()

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
	snek={{x=62,y=62,s=flr(rnd(4))+27,aim=becalmed, wire={x0=64, y0=64, x1=64,y1=64}}}
	tongue={x=64,y=64,x0=64,y0=64,x1=64,y1=64,x2=64,y2=64,x3=64,y3=64,c0=black,c1=black,c2=black,c3=black,}
	
end	



function update_snek()
	if (short>0)then
		short_circuit(snek[#snek])
	end		
	travel(snek[#snek])
	update_burnout()
	frame+=1
	if (frame >32700) frame=frame%32700
	if (frame%200==0) xray={}
end
function slither()
	local dy, dx, c, gridx, gridy,aim
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
	detect_collision(tongue.x,tongue.y)
		
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
	if (winner or gameover or fuses_blown) then
		if btnp(fire1)  then
			
			if outro then
				reload(0x1000, 0x1000, 0x2000)
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
		elseif btnp(fire1)  then
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
		burnouts[#burnouts].wait=.2+rnd(5)*.01
		burnouts[#burnouts].time=time()
	end
	if (#snek<short) then
		short=0
		if (#snek>0) then
			local new_head=snek[#snek]
			new_head.aim=head.aim
			
			speed=1.2
			
			new_head.wire={x0=new_head.x+4, y0=new_head.y+4,x0=new_head.x+4, y0=new_head.y+4}
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
	--if (fget(mget(gridx,gridy))==1) then  //if snek yard
		for i, bulb in pairs(bulbs) do
			if (bulb.x==gridx and bulb.y == gridy) then
				bulb.s=bulb.s-16 --row above
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
		--mset(gridx,gridy,1)
		
	--end
end
function update_tongue(head)
	if (head.aim==up) then
		tongue={
			x=head.x+2.5, y=head.y-1,
			x0=head.x+flr(2.5-rnd(1)), y0=head.y-flr(1-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(2.5+rnd(1)), y1=head.y-flr(1+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(2.5-rnd(1)), y2=head.y-flr(1+rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(2.5+rnd(1)), y3=head.y-flr(1-rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==down) then
		tongue={
			x=head.x+2.5, y=head.y+6,
			x0=head.x+flr(2.5-rnd(1)),y0=head.y+flr(5-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(2.5+rnd(1)),y1=head.y+flr(5+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(2.5-rnd(1)),y2=head.y+flr(5+rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(2.5+rnd(1)),y3=head.y+flr(5-rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==left) then
		tongue={
			x=head.x-1, y=head.y+2.5,
			x0=head.x-flr(1-rnd(1)), y0=head.y+flr(2.5-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x-flr(1+rnd(1)), y1=head.y+flr(2.5+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x-flr(1+rnd(1)), y2=head.y+flr(2.5-rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x-flr(1-rnd(1)), y3=head.y+flr(2.5+rnd(1)), c3=sparks[flr(rnd(4))+1]
		}
	elseif (head.aim==right) then
		tongue={
			x=head.x+5, y=head.y+2.5,
			x0=head.x+flr(5-rnd(1)), y0=head.y+flr(2.5-rnd(1)), c0=sparks[flr(rnd(4))+1],
			x1=head.x+flr(5+rnd(1)), y1=head.y+flr(2.5+rnd(1)), c1=sparks[flr(rnd(4))+1],
			x2=head.x+flr(5+rnd(1)), y2=head.y+flr(2.5-rnd(1)), c2=sparks[flr(rnd(4))+1],
			x3=head.x+flr(5-rnd(1)), y3=head.y+flr(2.5+rnd(1)), c3=sparks[flr(rnd(4))+1]
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
		line(wire.x0,wire.y0,wire.x1,wire.y1,dark_gray)
	end
	for i=1,#snek do
		if (not plugged_in) then
			
			spr(snek[i].s+48,snek[i].x,snek[i].y)
		else
			spr(snek[i].s,snek[i].x,snek[i].y)
		end	
	end
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
	if frame%15==0 then
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
--[[
it's after midnight, but you're not lazy like 
that other elf that just sits around spying children. 
You used to pull double shifts at the cobbler's after all.

the right jolly old elf wants says "string some lights, plug 'em in and connect the tree topper." 
"Easy!" you say. Too bad you didn't finished your electrian's course...

lrud to move x to unplug from outlet o to unplug from tree topper.

]]
 
function create_achievements()
	
	add(achievements,{text="\fa★\fb", hidden="^",locked=true})	--1
	add(achievements,{text="ti:me",hidden="ˇˇ", locked=false})	--2
	add(achievements,{text="big\f8◆\fbben",hidden="ˇˇˇˇ", locked=true})	--3
	add(achievements,{text="\f8◆\fbbonfire",hidden="ˇˇˇˇˇ", locked=true})		--4
	add(achievements,{text="low voltage\f8◆\fb",hidden="ˇˇˇˇˇˇ", locked=true})--5
	add(achievements,{text="\f8◆\fbhigh voltage",hidden="ˇˇˇˇˇˇ", locked=true})--6
	add(achievements,{text="robot\f8◆\fbdance",hidden="ˇˇˇˇˇˇ", locked=true})--7
	add(achievements,{text="sonar operator",hidden="ˇˇˇˇˇˇˇ", locked=true})--8
	add(achievements,{text="yule\f8◆\fblog tender",hidden="ˇˇˇˇˇˇˇˇ", locked=true})--9
	add(achievements,{text="x-ray vision\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇ", locked=true})--10
	add(achievements,{text="\f8◆\fbexploded 10 bulbs",hidden="ˇˇˇˇˇˇˇˇˇˇ", locked=true})--11
	add(achievements,{text="romantic\f8◆\fblighting\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇ", locked=true})--12
	add(achievements,{text="\f8◆\fbelectric candlelight\f8◆\fb",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=true})--13
	add(achievements,{text="longest\f8◆\fbstring 100 bulbs",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=true})--14
	if (star_connected)achievements[1].locked=false

	if (big_ben) achievements[3].locked=false
	if (bonfire) achievements[4].locked=false
	if (low_voltage) achievements[5].locked=false
	if (high_voltage) achievements[6].locked=false
	if (fire_lit) achievements[9].locked=false
	local xray_vision=0
	if (xray_bear) xray_vision+=1
	if (xray_doll) xray_vision+=1
	if (xray_diamond) xray_vision+=1
	if (xray_shirt) xray_vision+=1
	if xray_vision >0 then
		achievements[10].text = tostr(xray).."/4"
	end
	if (romantic) achievements[12].locked=false
	if left_candle_lit != right_candle_lit then
		achievements[13].text..="1/2"
		achievements[13].locked=false
	end
	if left_candle_lit and right_candle_lit then
		achievements[13].text..="2/2"
		achievements[13].locked=false
	end
	
	if winner and not conflagration and not fuses_blown then
		add(achievements,{text="deck the halls \f4⌂\fb ho, ho, ho!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	elseif fuses_blown then
		add(achievements,{text="shocking conclusion\f8◆\fbuh, oh!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	else	
		add(achievements,{text="smoke alarm sing along\f8◆\fbuh, oh!",hidden="ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ", locked=false})
	end	


	for achievement in all(achievements) do
		achievement.length=print(achievement.text,0,-16)
		achievement.locked_length=print(achievement.hidden,0,-16)
	end

end
function draw_achievements()
	color(green)
	local line=0
	for achievement in all(achievements) do
		if not achievement.locked then
			print(achievement.text,63-achievement.length\2,line)
		else
			print(achievement.hidden,63-achievement.locked_length\2,line)
		end	
		line=line + 8		
	end
	print("❎ replay", 49,line, brown)

end	
function _draw()
	
	if (not outro)	then
		if (#xray>0 and frame%3 >0 ) then
			rectfill(xray[1].x0,xray[1].y0,xray[1].x1,xray[1].y1,black)
			
			spr(xray[1].s,xray[1].x,xray[1].y,xray[1].w,xray[1].h)
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
						print("OH",10,18,lavendar)
						print("NO",23,18,lavendar)
						
					end	
					map(32,0)  --toys
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
					if conflagration and not fuses_blown then
						print("UH",10,18,lavendar)
						print("OH",23,18,lavendar)
					end
					
					if winner then
						print("❎achievements",70,117,charcoal)
						if (not conflagration) then
							print("HO",10,18,lavendar)
							print("HO",23,18,lavendar)	
							print("HO",10,34,lavendar)	
						end	
					end
				end	
				pal(light_palette)
				palt(black,true)
				if (not winner) draw_bulbs()
				draw_snek()
			else	
				print("❎ achievements",32,60,charcoal)
				print (fuses_blown,0,0,red)
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
	--local counter =0
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
0044fff44000000000575000000bbb0b3bb3b3bccbbb333cc0000bbb00000000453dd65a6b9d955a3d55d6d350444534355d535355505056050a551455555555
004f4f4f40000000000000000bbbbb3bb33b0b3b3b3333b00b0bbb00000000004653d3d65ddbd6bd6d66bdd6d4955555453435551350510f0155615400070000
004fffff40000000000500000bbb33333333b3b3333b3bbb03bb3b30000050004f7fffff763565dfff6fdffff67665666d5d55d555f5010d5511455400060000
004ff8ff4040000000888000000bb03bb33333333333333003b333b0000888004d66d6366d6d6666666dd666dd65636665f5f5d6455dfd053550f35400666000
4040fff00400000000888000000000333bb33bb3b330b3333b0bb000000888004dd66766666666666d646653665665d46ad65a5d546dddd65d5545d40666c600
04000f00000000000088800000000333b3333330bbbbb3333000b000000888004add6cdcd6d6dd6d66666ddd6da54df55ad5ad565a65d0045565d5f406666600
00088f8800f000000088800000bbbbb33b333bbb3333333b33b00000000888004dd66f666666d6d66d65fad5a6d55ada6d56d56ad6a51051d5ddf5d406666c00
00f88888ff00000004444400003b03bb03bb3bb333b33bbb33b0000000444440466d65666666666abfad6556dad456da5a3eddad5ad305006d4556a40d666d00
00f0888000000000444449900bbbbb3333333bb0bbbbbbbb00b0000b044449994d666566c6663addf5da63adada546d5315d5534d35d0105dadf1654000d0000
000ff880000000000000000000bb33333333b3b3b3bbbbbbbbbb00b3000000004666646d6adad7da5dd5f5d3666fdad5d55adadad515101adddd5ad406666600
000888880000000000000000000bbbb333333333b3bbbbbbbbbbbb0000000000466663fb6566ddadf5545ddadda66ddad656ada5a515050d555d5da46d666d60
00888888800000000003b0000000b00bbb33bb3bbbb0b33bb00bb30000bb000046666a56fda646d5d5dfb53a666fdadd55a55dad555d010addddd5546d666d70
0d8888888d000000000b00b000b0bbb333b33333b333bbbbbbbb0000bbb0000045666d47d95fa6ffda5d4a646fa6dda655da55da351d0551115353147d666d00
088ff5ff88000000000bbbb000bb0bbbb33bb330bbbb33bb33bbbb0b3b0000004dd664f7ad46666dd55f64adf7df664ada665555555515511515555400d0d000
0d55f5f55d0000000000b3bbb03bb333333bbb33b3bbbbbbbbbbbbbb3bb000004666cadfddd50ad46a6ada3476664dfd514555da65d51515115a6a6400706000
0000707000000000000030bbbbbb333b333333333bbb0b33000bbbbb3000000046d6654d5dd516a6a1d6ada5ad4f653d55ad55ada55d1d51511dadd400007000
0000101000000000000003bbb3bbb333b333333333b3bb3b0bb0bb33b00b0b3046cf6f4da6ad5f6b6d56ad5ad56a5ada55da11dad5dd55151515f44400000000
0000577777500000000000bb333b3bb33b3bb33333bb00bb0bbb3bbb00bb33bb4f65adadadad53af5d5fdada5a55a6a515555555d55151d51515555400070000
0005775757750000000000003333333b33333bbb333bbbb0033b33bbbbbb3bb04adadbf6da65555dad55a6ada6a535ddd5555d555d51d51d1511531400060000
0007507570575000000000bb3333333333b3333333b3bbbb333bbbb0033b330045b4ad96a355555f6415d303103055353555555531555d151551555400666000
0005757575750000000bb3333333b33b3bb33b33333b33333b33bb3b333b00004dadadad5511d511551555535015311535331313533515d11510553406c66600
000057575750000000bb0033bbb33b3333333333333333333bb003333b0000004a5a6da655551555555053050155353535555050350555115115555406666600
0000057575000000000bbbb3b3bb3b333333bb333b33333bbbb00b33333000b04a6da6a155555dd56d1555501053505053353535553551d1515151340c666600
00000057500000000000b3bb3b3333b3333b33333b333333bbbbbbb3b33bbb0046a5dd313535d45d635005005050530351553535355555d1511155540d666d00
00000005000000000000333b333333bbb3b3333b3bbb3300bb3b03bbb0033000435dddd555554ddd55555050350355534b5555355535515d15505534000d0000
0009000000000000000000003333b3b333333333333333bb3b3b00000000033045d5dddd554d4d5a155550550055555dd4d5dd55535051111115050406666600
000a0000000000000000000333b33333333303333b33330bbb3bbb0bbbb00000444444444444444444444444444444444444444444444444444444446d666d60
008880000000000000b00000b3333b33b333bb0bbbb3b0b3330bbbbb33330000f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff6d666d70
008880000000000000b03000b33b303333b3330b0b0000bb0bbb333000000bbb7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7d666d00
00888000000000000bb3bb000b33bb00bb3bb3bbbb3bbb33333b00b0bb0b0330f777fff7f777fff7f777fff7f777fff7f777fff7f777fff7f777fff700d0d000
008880000000000000b33bb3bbbbb0b0bb33b333bbbbbb33333b33bbbbb030007777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff00706000
04444400000000000000bbbbb0bb3bb0033333333bb0b3333bb3bbbbbb330000f7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7fff7f7f7ff00007000
4444499000bbbbb0bbbbbbb3300b3bbb0bbbbbb3bb3bb333333bbbb0330000bb7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff7777ffff00000000
000000000033333bbbbb03333bbbb3bbbb00bbb3333b333333333bb0bbbbb3bb30000000f777fff7f75444f7f777fff788888898888888800000900000070000
00000000000b0b3b33bbb333333bbbbbbb3bb03bb333333333b33bb3333b33b0000000007777ffff7547774f7777ffff88888898888888800000a00000060000
00000000000000b033333333033b3bb33b33bb0bb33333bbb3333bb333bbb00b00000000f7f7f7ff5477d774f7f7f7ff88888898888888800008880000666000
0000007000000003333333333bb333b3b333b0b00033b33333b333bb3b3b0b00bbbb00007777ffff54775d747777ffff88888898888888800008880006c6c600
0000009000000bb33b0b333333333333333333333bb33333333333bb3b00b3b033300000f777fff754777774f777fff788888898888888800008880006666600
070700900000000000b3333b33333b33333333330b3333333333bbbb3bbb333b3bbb00007777ffff544777447777ffff888888988888888000088800066c6600
00990a9a0000000000b3b3333b33b3b3333bb33bbbb33b3bbbbb33b3333b333003000000f7f7f7f54444444447f7f7ff8888889888888880004444400d666d00
0799a9990000000000000b00bb333b3333333333333b3bb33333333bb3333b333b0000007777f544444444444447ffff888889998888888004444999000d0000
000a9aaa000000000000000000033333b33b333bbbbbb0b333333333333333300000b00000000000000005555500000088889989988888800000000006666600
7999aa9a00b3333b00000b0033333b03b3333bbbbbbbbb3b03333333333bbb33bbbb3bb00000000005555777775555009999989899999990000000006d666d60
000a9aaa00003b3b33333333bb3333b33333333333b3333bb300333bb0bb0000033b33000000000057777555057777508888898988888880000099006d666d60
0799a999000003b0b3333330333b333b3333b3333b33bbbb00b0b3bb0bbb0000333b00000000000075555750575575758889989898888849990999907d666d70
00990a9a000000003bb3bb3bbbbbbb3b33b3333333b33bbbbbbbb3bbbbb0b0bb3b00000000000000750057757757507588888898898884990999099000d0d000
0707009000000000bb3b0bbbbbb33333333b3bb333b0bbbb3bb3b3bbb333bb33333000b007070000750057500775007588888898888884990999099000606000
0000009000bb000000b3b00b33bbb333333333b3333bbb3bb333bbbb3bbbbb00b33bbb0009900000750005070750007588888898888884990999099000707000
0000099900b3bb0000bbbbbbbb3bbb333b3333333333b33bb3333333b3bb3000b0033000a9970000750000057500007588888898844444999999990000000000
000000000bb333b0bbbbbb3b3bb333333bbbb333333bbb3bb30333333bb3bb00000000000bb00000750000570000057588888898848888899998888888000000
00000000000b33bbbbb00033b0b3333300bb00bb33bbbbbbb33b33b333b0bb00000bbbb330000000750005750000577588888898848888888998888888000000
00000000000003333bb333bb000b3b0b000bbbb0bb00bbb333bb3333333bbbbb03bb3b3300000000750057500055757588888898848888888998888888000000
000000000000b3333bb333333333bbbbb3bb30bb0bbb3333333333333333bbbb333bbb0000000000750577500577507588888898848888888998888888000000
00000000000b3bb3333333333b3bbbbb3333333b0bbbbbbbb333333bbb33bbb33333000000000000755700755755007588888898849999999999999999000000
0000000000bbbb3bb3333b33b33bbb333333303bbbbb0bb33bb333333bb3bbbbb300000000000000750570077500007588888898849999999999999999000000
00bbbb3bbb3bbbbb33bb33333bb333333333333333bb3bb3333b3333bb3bbbbbbb0bbbbbbbb00000750057755000007588888898808888888998888888000000
00003333b3333bbb33333b333b3b333b33b3333b333333333333333b333b33b33bb0bbb3bb000000750005500000007500000000008888888998888888000000
0000b00bb3b3333b333333b3333333333b333bb33333b3333333b333333333b3bbb30000b000000075000007000005759a000000008888888998888888000000
0000000b3303333b33333333333b3b03333b333333333bb3b000b0b033333bb33bbbb300000000007500000500000575a9997000008888888998888888000000
0000000b0000b0bbb3333330b3033033330033333333333000000303bb3b30bbbbbbbbb00000000057500000000057509a000000000000000000000000000000
0000000000000000b033b000000bb3b300000333b00b00000000003003b0b300b33b0b00000000000575000700057500a9970000000000000000000000000000
00000000000000000bb300000000bb3300000333b0000000000000300003000000b3000000000000005755555557500009900000000000000000000000000000
00000000000000000000000000000b0b00000033b0000000000000b0000300000000b00000000000000577777775000007070000000000000000000000000000
0000000000000000000000000000b00000000033b00000000000000b000000000000000000000000000055555550000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000002020000000080000000000000000000020200000000800000000000000000000000000000008000000000010100000000000000000000000000000101000000000000000000000000000101010000000000000000000000000001010101000000000000000000
0000010101010101000000000000000000000101010101010000000000000000000001010101010100000000000000008001010101010101000000000000000004010101010101010100000000008000040101010101010101040000000000000101010101010101010100000000000001010101010101010101000004000000
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
000106003f67030050210501965010050086500100000000190000000000000140000000011000100000f0000d0000a000000000800008000080000000008000080000a0000c0000d00000000000000000000000
0101000022060220503a005270652704027020305052a505361003650036505365053450029500295002f5003f500335003450029500295002f5003f500335003450029500295002f5003f500005000050000500
010f00001d54500500005001f5451d545005001a53500500005000050000500005001d54500500005001f5451d535005001a54500500005000050000500005002455500500005000050024545005002153500500
010f1c00000000000000000000002254500000000000000022545000001d53500000000000000000000000001f5450000000000000001f54500000225450000000000215451f545000001d54500000000001f545
490f00001d54500500005001f5451d545005001a53500500005000050000500005001d54500500005001f5451d535005001a54500500005000050000500005002455500500005000050024545005002153500500
490f1c00000000000000000000002254500000000000000022545000001d53500000000000000000000000001f5450000000000000001f54500000225450000000000215451f545000001d54500000000001f545
910f00001d54500500005001f5451d545005001a53500500005000050000500005001d54500500005001f5451d535005001a54500500005000050000500005002455500500005000050024545005002153500500
910f1c00000000000000000000002254500000000000000022545000001d53500000000000000000000000001f5450000000000000001f54500000225450000000000215451f545000001d54500000000001f545
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
02 34404040
01 35404040
02 36424344