#define init
global.sprToxicCannon = sprite_add_weapon("sprites/sprToxicCannon.png", 4, 4);
#define weapon_name
return "TOXIC CANNON";

#define weapon_sprt
return global.sprToxicCannon;

#define weapon_type
return 4;

#define weapon_auto
return false;

#define weapon_load
return 34;

#define weapon_cost
return 3;

#define weapon_swap
return sndSwapExplosive;

#define weapon_area
return 8;

#define weapon_text
return "HOW LONG CAN YOU HOLD YOUR BREATH?";

#define weapon_fire

weapon_post(6,-8,15)
sound_play_pitch(sndToxicBarrelGas,.8)
sound_play_pitch(sndToxicLauncher,.6)
sound_play_pitch(sndHeavyCrossbow,.6)
with instance_create(x,y,FrogQueenBall)
{
	move_contact_solid(other.gunangle,18)
	motion_set(other.gunangle,3)
	creator = other
	team = other.team
}