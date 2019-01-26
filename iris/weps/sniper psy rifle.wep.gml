#define init
global.sprSniperPsyRifle = sprite_add_weapon("sprites/sprSniperPsyRifle.png", 5, 3);
global.sprPsyBullet 		 = sprite_add("defpack tools/Psy Bullet.png", 2, 8, 8);
global.sprPsyBulletHit   = sprite_add("defpack tools/Psy Bullet Hit.png", 4, 8, 8);
global.epic = 1
mod_script_call_nc("mod","defpermissions","permission_register","weapon",mod_current,"epic","Homing Psy Sights")

#macro lasercolor 14074

#define weapon_name
return "PSY SNIPER RIFLE"

#define weapon_chrg
return true;

#define weapon_sprt
return global.sprSniperPsyRifle;

#define weapon_type
return 1;

#define weapon_auto
return 1;

#define weapon_load
return 20;

#define weapon_cost
return 20;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_laser_sight
with instances_matching(instances_matching(CustomObject, "name", "sniper psy charge"),"creator",self){
    with other
    if global.epic{
        with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomObject){
            move_contact_solid(other.gunangle,18)
            draw_line_width_color(other.x, other.y, x, y, 1, lasercolor, lasercolor)
            typ = 1
            sprite_index = mskBullet2
            image_angle = other.gunangle
            direction = image_angle
            team = other.team
            hyperspeed = 8
            bangle = image_angle
            lasthit = -4
            image_yscale = .5
            
            var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
                slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
                shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
                customslashes = instances_matching_ne(CustomSlash, "team", team),
                olddirection = direction;
            var dir = 0
            do
            {
                var _x = x; var _y = y
            	dir += hyperspeed
            	x += lengthdir_x(hyperspeed,direction)
            	y += lengthdir_y(hyperspeed,direction)
            	olddirection = direction
            	with shields {if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction}}
            	with slashes {if place_meeting(x,y,other){other.team = team;other.direction = direction ;other.image_angle = other.direction}}
            	with shanks  {if place_meeting(x,y,other){with other{instance_destroy();exit}}}
            	with customslashes {if place_meeting(x,y,other){mod_script_call_self(on_projectile[0],on_projectile[1],on_projectile[2]);}}
            	if direction != olddirection{
            	    bangle = direction
                    var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
                        slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
                        shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
                        customslashes = instances_matching_ne(CustomSlash, "team", team);
            	}
        	    draw_line_width_color(x, y, _x, _y, 1, lasercolor, lasercolor)
        
            	var q = instance_nearest_matching_ne(x,y,hitme,"team",team);
            	var reset = 1;
                var cap = 3*hyperspeed;
            	if instance_exists(q){
            	    if !collision_line(x - lengthdir_x(hyperspeed,direction),y - lengthdir_y(hyperspeed,direction),q.x,q.y,Wall,1,1){
                        var ang1 = point_direction(x,y,q.x,q.y),
                            ang2 = angle_difference(direction,ang1);
                        if abs(ang2) < 90{
                            direction -= clamp(ang2,-cap,cap)
                            reset = 0
                        }
            	    }
            	}
            	if reset{
            	    direction -= clamp(angle_difference(direction,bangle),-cap,cap)
            	}
        
            	if place_meeting(x,y,Wall){instance_destroy()}
            }
            while instance_exists(self) and dir < 500
            if instance_exists(self)
                instance_destroy()
        
        }
        return false;
    }
    return true;
}
return false
#define weapon_reloaded
with mod_script_call("mod","defpack tools", "shell_yeah_long", 100, 8, 3+random(2),c_purple)
var _r = random_range(.8,1.2)
sound_play_pitchvol(sndSwapPistol,2*_r,.4)
sound_play_pitchvol(sndRecGlandProc,1.4*_r,1)
weapon_post(-2,-4,5)

#define weapon_area
return -1;

#define weapon_text
return choose("insanity");

#define weapon_fire

with instance_create(x,y,CustomObject)
{
	name    = "sniper psy charge"
	creator = other
	charge  = 0
	index = other.index
	acc     = other.accuracy
	charged = 1
	holdtime = 5 * 30
	depth = TopCont.depth
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = snipercharge_step
	on_cleanup = snipercharge_destroy
	on_destroy = snipercharge_destroy
	btn = other.specfiring ? "spec" : "fire"
}

#define snipercharge_step
var timescale = (mod_variable_get("weapon", "stopwatch", "slowed") == 1) ? 30/room_speed : current_time_scale;
if !instance_exists(creator){instance_destroy();exit}
if button_check(index,"swap"){creator.ammo[1] = min(creator.ammo[1] + weapon_cost(), creator.typ_amax[1]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec"{
    if creator.race = "steroids"
        creator.breload = weapon_get_load(creator.bwep)
    else
        creator.reload = max(weapon_get_load(creator.wep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", name),"creator",creator),"btn",btn)), creator.reload)
}
charge += timescale * 3.2 / acc
if charge > 100
{
	charge = 100
	if charged > 0
	{
		sound_play_pitch(sndSniperTarget,1.2)
	}
	charged = 0
}
if charged = 0
{
	if holdtime >= 60 {var _m = 5}else{var _m = 3}
    if current_frame mod _m < current_time_scale creator.gunshine = 1
	with creator with instance_create(x,y,Dust){
		motion_add(random(360),random_range(2,3))
	}
	holdtime -= timescale
}
view_pan_factor[index] = 2.1+charged/10
sound_play_pitchvol(sndFlameCannonLoop,10-charge/10,1)
sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,.00001)
x = mouse_x[index]
y = mouse_y[index]
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,0)}
if button_check(index, btn) = false || holdtime <= 0
{
    sound_stop(sndFlameCannonLoop)
	sound_play_gun(sndFootOrgSand4,999999999999999999999999999999999999999999999999,1)
	sound_pitch(sndNoSelect,1)
	var _ptch = random_range(-.5,.5)
	sound_play_pitch(sndHeavyRevoler,.7-_ptch/3)
	sound_play_pitch(sndCursedPickup,.6)
	sound_play_pitch(sndSniperFire,random_range(.6,.8))
	sound_play_pitch(sndHeavySlugger,1.3+_ptch/2)
	var _c = charge
	with creator
	{
		weapon_post(12,2,158)
		motion_add(gunangle -180,_c / 20)
		with instance_create(x+lengthdir_x(10,gunangle),y+lengthdir_y(10,gunangle),CustomProjectile)
		{
				move_contact_solid(other.gunangle,18)
				typ = 1
				creator = other
				index = other.index
				team  = other.team
				image_yscale = .5
				trailscale = 1 + (_c/110)
				hyperspeed = 8
				sprite_index = mskNothing
				mask_index = mskBullet2
				force = 7
				damage = 12 + round(28*(_c/100))
				lasthit = -4
				dir = 0
				dd = 0
				recycleset = 0
				image_angle = other.gunangle
				direction = other.gunangle
				bangle = direction
				on_end_step 	 = sniper_step
				on_destroy = sniper_destroy
				on_hit 		 = void
		}
		with instance_create(x,y,CustomObject)
		{
			move_contact_solid(other.gunangle,24)
			depth = -1
			sprite_index = global.sprPsyBullet
			image_speed = .4
			on_step = muzzle_step
			on_draw = muzzle_draw
		}
	}
	sleep(charge)
	instance_destroy()
}

#define snipercharge_destroy
view_pan_factor[index] = undefined
for (var i=0; i<maxp; i++){player_set_show_cursor(index,i,1)}

#define void

#define sniper_step
var trails = [];
var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
    slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
    shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
    customslashes = instances_matching_ne(CustomSlash, "team", team),
    enemies = instances_matching_ne(hitme, "team", team),
    olddirection = direction;

do
{
	dir += hyperspeed
	x += lengthdir_x(hyperspeed,direction)
	y += lengthdir_y(hyperspeed,direction)
	olddirection = direction
	with shields {if place_meeting(x,y,other){other.team = team;other.direction = point_direction(x,y,other.x,other.y);other.image_angle = other.direction;with instance_create(other.x,other.y,Deflect){image_angle = other.direction;sound_play_pitch(sndCrystalRicochet,random_range(.9,1.1))}}}
	with slashes {if place_meeting(x,y,other){other.team = team;other.direction = direction ;other.image_angle = other.direction}}
	with shanks  {if place_meeting(x,y,other){with other{instance_destroy();exit}}}
	with customslashes {if place_meeting(x,y,other){mod_script_call_self(on_projectile[0],on_projectile[1],on_projectile[2]);}}
	if direction != olddirection{
	    bangle = direction
        var shields = instances_matching_ne([CrystalShield,PopoShield], "team", team),
            slashes = instances_matching_ne([EnergySlash,Slash,EnemySlash,EnergyHammerSlash,BloodSlash,GuitarSlash], "team", team),
            shanks = instances_matching_ne([Shank,EnergyShank], "team", team),
            customslashes = instances_matching_ne(CustomSlash, "team", team),
            enemies = instances_matching_ne(hitme, "team", team);
	}
	
	var q = instance_nearest_matching_ne(x,y,hitme,"team",team);
	var reset = 1;
    var cap = 3*hyperspeed;
	if instance_exists(q){
	    if !collision_line(x - lengthdir_x(hyperspeed,direction),y - lengthdir_y(hyperspeed,direction),q.x,q.y,Wall,1,1){
            var ang1 = point_direction(x,y,q.x,q.y),
                ang2 = angle_difference(direction,ang1);
            if abs(ang2) < 90{
                direction -= clamp(ang2,-cap,cap)
                reset = 0
            }
	    }
	}
	if reset{
	    direction -= clamp(angle_difference(direction,bangle),-cap,cap)
	}
	with instance_create(x,y,BoltTrail){
	    image_xscale = other.hyperspeed
	    image_yscale = other.trailscale
	    image_blend = c_fuchsia
	    image_angle = other.direction
	    array_push(trails,id)
	}

	with enemies{
		if mask_index != mskNone and distance_to_object(other) <= other.trailscale * 3 and other.lasthit != id{
			with other{
                projectile_hit(other,damage,force,direction)
                lasthit = other
                view_shake_at(x,y,12)
                sleep(20)
                if skill_get(16) = true && recycleset < weapon_cost() and !irandom(1){
				    recycleset += 3;
				    instance_create(x,y,RecycleGland);
				    sound_play(sndRecGlandProc);
				    creator.ammo[1] = min(creator.ammo[1] + 3, creator.typ_amax[1])
			    }
			}
		}
	}
	if place_meeting(x,y,Wall){instance_destroy()}
}
while instance_exists(self) and dir < 1000
instance_destroy()
var a = array_length(trails);
for var i = 0; i < a; i++{
    with trails[i]{
        image_yscale *= i/a
    }
}



#define instance_nearest_matching_ne(_x,_y,obj,varname,value)
var num = instance_number(obj),
    man = instance_nearest(_x,_y,obj),
    mans = [],
    n = 0,
    found = -4;
if instance_exists(obj){
    while ++n <= num && variable_instance_get(man,varname) = value || (instance_is(man,prop) && !instance_is(man,Generator)){
        man.x += 10000
        array_push(mans,man)
        man = instance_nearest(_x,_y,obj)
    }
    if variable_instance_get(man,varname) != value && (!instance_is(man,prop) || instance_is(man,Generator)) found = man
    with mans x-= 10000
}
return found


#define sniper_destroy
with instance_create(x,y,BulletHit) sprite_index = global.sprPsyBulletHit

#define muzzle_step
if image_index > 1{instance_destroy()}

#define muzzle_draw
draw_sprite_ext(sprite_index, image_index, x, y, 2*image_xscale, 2*image_yscale, image_angle, image_blend, 1.0);
draw_set_blend_mode(bm_add);
draw_sprite_ext(sprite_index, image_index, x, y, 3*image_xscale, 3*image_yscale, image_angle, image_blend, 0.3);
draw_set_blend_mode(bm_normal);
