#define init
global.sprHeavyNuke = sprite_add("sprHeavyNuke.png",0, 8, 6);
global.sprHeavyNukeLauncher = sprite_add_weapon("sprHeavyNukeLauncher.png", 9, 7);
global.sprSmallGreenExplosion = sprite_add("GreenExplosionS.png",7,12,12)
global.sprHeavyNukeFlame = sprite_add("sprHeavyNukeFlame.png",3,36,12)
global.sprUltraFire = sprite_add("sprUltraFire.png",7,8,8);
#define weapon_name
return "HEAVY NUKE LAUNCHER";

#define weapon_sprt
return global.sprHeavyNukeLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 75;

#define weapon_cost
return 6;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 15;

#define weapon_text
return choose("THIS IS WHAT WILL END IT ALL","STANDING, ON THE EDGE","WHAT A MESS WE MADE","A HEART OF BROKEN GLASS");

#define weapon_fire
sound_play(sndRocket)
sound_play_pitch(sndHeavyNader,1)
weapon_post(15,-16,32)
motion_add(gunangle,-5)
with instance_create(x,y,CustomProjectile){
	friction = .18
	motion_set(other.gunangle, 5)
	team = other.team
	creator = other
	sprite_index = global.sprHeavyNuke
	index = other.index
	typ = 2
	timer = 25
	damage = 100
	fimage_index = 0
	soundcheck = 0
	on_step = script_ref_create(nuke_step)
	on_destroy = script_ref_create(nuke_pop)
	on_draw = script_ref_create(nuke_draw)
	repeat(12)
	with instance_create(x+lengthdir_x(speed,direction),y+lengthdir_y(speed,direction),Smoke)
	{
		motion_add(other.direction+random_range(-30,30)*other.creator.accuracy,2+random(2))
	}
}
sleep(70)

#define nuke_step
if timer > 0{timer -= 1}
else
{
	if fimage_index < 2{fimage_index += .5}
	else
	{
		fimage_index = 0
	}
}
var _x = mouse_x[index]
var _y = mouse_y[index]
if instance_exists(creator) {
	if timer <= 0 && speed >= 3{motion_add(point_direction(x,y,_x,_y),.6)}
	image_angle = direction
}
if timer <= 0
{
	if !soundcheck
	{
		soundcheck = 1
		view_shake_at(x,y,22)
		sound_play(sndNukeFire)
		repeat(22)
		with instance_create(x- hspeed*2, y - vspeed*2, Flame)
		{
			team = other.team
			sprite_index = global.sprUltraFire
			motion_add(other.direction-180+random_range(-4,4),random_range(1,5))
			image_xscale /= speed
			image_yscale = image_xscale
			damage = 8
		}
	}
	if speed < 6{friction = -.4}
	else{speed = 6}
	with instance_create(x- hspeed*2, y - vspeed*2, Smoke) {
		motion_set(other.direction+random_range(-8,8)-180,2+random(2))
	}
}
if place_meeting(x, y, Explosion){
	instance_destroy()
}

#define nuke_pop
sleep(160)
view_shake_max_at(x,y,600)
repeat(13){
	with instance_create(x + random_range(-40,40), y + random_range(-40,40), GreenExplosion)
	{
		hitid = [sprite_index,"green#Explosion"]
	}
}
repeat(7){
	with instance_create(x + random_range(-40,40), y + random_range(-40,40), SmallExplosion){
		damage = 12
		image_speed = .3
		sprite_index = global.sprSmallGreenExplosion
		hitid = [sprite_index,"Small green#Explosion"]
	}
}
sound_play(sndNukeExplosion)
sound_play_pitch(sndExplosionL,.7)
sound_play_pitch(sndExplosionXL,.9)
sound_play_pitch(sndHitMetal,.03)
#define nuke_draw
if timer <= 0{draw_sprite_ext(global.sprHeavyNukeFlame,fimage_index,x,y,.75,.75,direction,c_white,1)}
draw_self()
