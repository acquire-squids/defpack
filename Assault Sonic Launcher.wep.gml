#define init
global.sprAssaultSonicLauncher = sprite_add_weapon("sprites/weapons/sprAssaultSonicLauncher.png", 4, 2);
global.sprTripleSonicNade      = sprite_add("sprites/projectiles/sprSonicGrenade.png",1,3,3);
global.sprSonicStreak          = sprite_add("sprites/projectiles/sprSonicStreak.png",6,8,32);

#define weapon_name
return "ASSAULT SONIC LAUNCHER"

#define weapon_sprt
return global.sprAssaultSonicLauncher;

#define weapon_type
return 4;

#define weapon_auto
return true;

#define weapon_load
return 34;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 9;

#define weapon_text
return "SO LOUD";

#define weapon_fire
	repeat(3)
	if instance_exists(self){
		with instance_create(x,y,CustomProjectile){
			move_contact_solid(other.gunangle,6)
			sprite_index = global.sprTripleSonicNade
			team = other.team
			creator = other
			friction = .5
			damage = 6
			force = 5
			bounce = 3
			typ = 1
			dt = 4
			anglefac = choose(1,-1)
			if other.object_index = Player{
				var _x = mouse_x[other.index]+random_range(-22,22)*other.accuracy;
				var _y = mouse_y[other.index]+random_range(-22,22)*other.accuracy;
				motion_add(point_direction(x,y,_x,_y),max(sqrt(point_distance(_x,_y,x,y)),10))
			}else{
				motion_add(other.gunangle,10)
			}
			sound_play_pitch(sndHyperLauncher,1.3+(speed-10)/20)
	    	on_step    = sonic_launcher_step
	    	on_wall    = sonic_wall
	    	on_destroy = sonic_launcher_destroy
		}
		sound_play_pitch(sndHeavyNader,1.8)
		sound_play_pitch(sndNothingFire,.7)
		weapon_post(7,-6,7)
		wait(4)
	}

#define sonic_wall
	instance_create(x,y,Dust)
	move_bounce_solid(false)
	bounce -= 1
	sound_play_pitch(sndBouncerBounce,random_range(1.6,1.8))
	with instance_create(x+lengthdir_x(12,direction),y+lengthdir_y(12,direction),AcidStreak){
		sprite_index = global.sprSonicStreak
		image_angle = other.direction - 90
		motion_add(image_angle+90,12)
		friction = 2.1
	}

#define sonic_launcher_step
	if dt > 0 dt -= current_time_scale
	else if dt > -1{
	    dt = -1
		repeat(4) with instance_create(x,y,Dust){
			motion_add(random(359),random_range(0,2))
		}
	}
	image_angle += anglefac * speed/1.5 * current_time_scale
	if speed <= 0 || bounce <= 0{
		instance_destroy()
	}

#define sonic_launcher_destroy
	with mod_script_call("mod","defpack tools","create_sonic_explosion",x - lengthdir_x(2, direction),y - lengthdir_y(2, direction)){
		var scalefac = random_range(0.6,0.75);
		image_xscale = scalefac
		image_yscale = scalefac
		image_speed = 0.6
		team = other.team
		creator = other.creator
		sound_play(sndExplosion)
		repeat(round(scalefac*10)){ with instance_create(x,y,Dust) {sprite_index = sprExtraFeet; motion_add(random(360),3)}}
	}
	var _a = random(360)
	repeat(3){
		with instance_create(x+lengthdir_x(36,_a),y+lengthdir_y(36,_a),AcidStreak){
			sprite_index = global.sprSonicStreak
			image_angle = _a - 90
		}
		_a += 120
	}
