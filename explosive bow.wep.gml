#define init
global.sprExplosiveBow   = sprite_add_weapon("sprites/sprHotCrossbow.png", 2, 3);
global.sprHotArrow  	   = sprite_add("sprites/projectiles/sprHotBolt.png",0, 1, 5);
global.sprHotArrowHUD  	 = sprite_add_weapon("sprites/projectiles/sprHotBolt.png", 7, 5);

#define weapon_name
return "EXPLOSIVE BOW"

#define weapon_sprt
return global.sprExplosiveBow;

#define weapon_type
return 3;

#define weapon_auto
return false;

#define weapon_load
return 8;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapHammer;

#define weapon_area
return 6;

#define weapon_text
return "CHECK THE ROUTES";

#define weapon_sprt_hud
return global.sprHotArrowHUD;

#define weapon_fire
with instance_create(x,y,CustomObject)
{
    sound = sndAssassinAttack
    sound_set_track_position(sound,.11)
	name    = "bow charge"
	creator = other
	charge    = 0
  maxcharge = 30
	charged = 0
	holdtime = 5 * 30
	depth = TopCont.depth
	index = creator.index
	undef = view_pan_factor[index]
	on_step 	 = bow_step
	on_destroy = bow_destroy
	on_cleanup = bow_cleanup
	btn = other.specfiring ? "spec" : "fire"
}

#define bow_step
if !instance_exists(creator){instance_destroy();exit}
with creator weapon_post(0,-(other.charge/2),0)
if button_check(index,"swap"){creator.ammo[3] = min(creator.ammo[3] + weapon_cost(), creator.typ_amax[3]);instance_destroy();exit}
if btn = "fire" creator.reload = weapon_get_load(creator.wep)
if btn = "spec" creator.breload = weapon_get_load(creator.bwep) * array_length_1d(instances_matching(instances_matching(instances_matching(CustomObject, "name", "bow charge"),"creator",creator),"btn",btn))
if button_check(index,btn){
    if charge < maxcharge{
      charge += current_time_scale;
      charged = 0
      sound_play_pitchvol(sound,sqr((charge/maxcharge) * 1.2) + .2,.6)
      sound_set_track_position(sound,.15)
    }
    else{
        if current_frame mod 6 < current_time_scale creator.gunshine = 1
        charge = maxcharge;
        if charged = 0{
            instance_create(creator.x,creator.y,WepSwap);
            charged = 1
        }
    }
}
else{instance_destroy()}

#define weapon_reloaded
return -4

#define bow_cleanup
sound_set_track_position(sound,0)
sound_stop(sound)

#define bow_destroy
bow_cleanup()
var _p = random_range(.8,1.2)
sound_play_pitchvol(sndSwapGuitar,4*_p,.8)
sound_play_pitchvol(sndAssassinAttack,2*_p,.8)
sound_play_pitchvol(sndClusterOpen,2*_p,.2)
with instance_create(creator.x,creator.y,Bolt)
{
	sprite_index = global.sprHotArrow
	creator = other.creator
	team = creator.team
	check = 0
	charged = other.charged
	motion_add(creator.gunangle+random_range(-8,8)*creator.accuracy*(1-(other.charge/other.maxcharge)),16+6*other.charge/other.maxcharge)
	damage = 12
	image_angle = direction
	if fork(){
		while(instance_exists(self)){
			image_angle = direction
				if speed <= 0 || place_meeting(x + hspeed,y + vspeed,enemy)
				{
					sprite_index = mskNothing
					if check = 0
					{
						check = 1
						with instance_create(x + hspeed,y + vspeed,Flare)
						{
							team = other.team
							instance_destroy()
						}
						sound_play(sndFlareExplode)
						if charged = 1 instance_create(x+lengthdir_x(10,direction),y+lengthdir_y(10,direction),SmallExplosion)
					}
				}
				else
				{
					repeat(1+charged*3)
					{
						with instance_create(x+random_range(-8,8),y+random_range(-8,8),Flame)
						{
							team = other.team
						}
					}
				}
			wait(1)
		}
		exit
	}
}
