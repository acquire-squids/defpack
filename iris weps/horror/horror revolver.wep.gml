#define init
global.sprHorrorRevolver = sprite_add_weapon("../../sprites/weapons/iris/horror/on/sprHorrorRevolverOn.png", -2, 1);

#define weapon_name
return "HORROR REVOLVER";

#define weapon_sprt
return global.sprHorrorRevolver;

#define weapon_type
return 1;

#define weapon_auto
return false;

#define weapon_load
return 6;

#define weapon_cost
return 1;

#define weapon_swap
return sndSwapPistol;

#define weapon_area
return -1;

#define weapon_text
return "@gHORROR @sBULLETS DELETE @wENEMY PROJECTILES";

#define weapon_fire

weapon_post(2,-3,2)
sound_play_pitch(sndMinigun,random_range(1.2,1.5))
sound_play_pitch(sndPistol,random_range(.6,.8))
mod_script_call("mod","defpack tools", "shell_yeah", 100, 25, random_range(3,5), c_lime)
repeat(3) with instance_create(x+lengthdir_x(8,gunangle),y+lengthdir_y(8,gunangle), HorrorBullet){
    creator = other
    team = other.team
    motion_set(other.gunangle + random_range(-24,24) * other.accuracy,random_range(10,18))
	  image_angle = direction
}
