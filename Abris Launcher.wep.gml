#define init
global.sprAbrisLauncher = sprite_add_weapon("sprites/sprAbrisLauncher.png", 0, 3);
global.stripes = sprite_add("defpack tools/BIGstripes.png",1,1,1)

#define weapon_name
return "ABRIS LAUNCHER"

#define weapon_sprt
return global.sprAbrisLauncher;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 24;

#define weapon_cost
return 2;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "HIDE AND KILL";

#define weapon_fire
var _strtsize = 50;//never thought id have to nerf eagle eyes im so proud of you
var _endsize  = 30;
var _accspeed = 1.2;
with mod_script_call("mod","defpack tools","create_abris",self,_strtsize,_endsize,argument0){
	accspeed = 1.2
	payload = script_ref_create(pop)
}
sound_play_pitch(sndSniperTarget,1/accuracy+.5)
#define pop
sound_play_pitch(sndGrenadeRifle,random_range(.5,.8))
sound_play_pitch(sndGrenade,random_range(.5,.8))
sound_play_pitch(sndGrenadeShotgun,random_range(.5,.8))
sound_play(sndExplosion)
creator.wkick = 6
repeat(6)
{
	with instance_create(explo_x+lengthdir_x(acc+30,offset),explo_y+lengthdir_y(acc+30,offset),SmallExplosion){hitid = [sprite_index,"small explosion"]}
	offset += 360/6
}
