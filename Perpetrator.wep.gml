#define init
global.sprPerpetrator = sprite_add_weapon("Perpetrator.png", 5, 2);
global.sprGenShell = sprite_add("Generic Shell.png",0, 1.5, 2.5);
global.sprDual = sprite_add("sprDual.png",9,4,4)

#define weapon_name
return "PERPETRATOR";

#define weapon_sprt
return global.sprPerpetrator;

#define weapon_type
return 1;

#define weapon_auto
return true;

#define weapon_load
if wep = "undulator" && bwep = "perpetrator" || bwep = "undulator" && wep = "perpetrator"{return 7}else{return 9};

#define weapon_cost
return 5;

#define weapon_swap
return sndSwapMachinegun;

#define weapon_area
return 20;

#define weapon_text
return choose("READY FOR ACTION","THE LAST STANCE","DELETE THEM");

#define weapon_fire
repeat(2)
{
	sound_play_pitch(sndHyperLauncher,500)
	sound_play_pitch(sndHyperSlugger,random_range(.7,.8))
	sound_play_pitch(sndHeavySlugger,.8)
	if wep = "undulator" && bwep = "perpetrator" || bwep = "undulator" && wep = "perpetrator"{sound_play_pitch(sndExploGuardianFire,.6)};
	with instance_create(x,y,Shell)
	{
		sprite_index = global.sprGenShell
		motion_add(other.gunangle+other.right*100+random(50)-25,2+random(5))
		image_blend = c_black
	}

	with mod_script_call("mod", "defpack tools", "create_dark_bullet",x+lengthdir_x(2,gunangle),y+lengthdir_y(2,gunangle)){
		creator = other
		team = other.team
		motion_set(other.gunangle+random_range(-2,2)*other.accuracy,14)
		image_angle = direction
	}
	weapon_post(5,-8,24)
	if wep = "undulator" && bwep = "perpetrator" || bwep = "undulator" && wep = "perpetrator"{wait(2)}else{wait(3)}
	if (!instance_exists(self)) break;
}
wait(3)
sound_play_pitch(sndHyperLauncher,random_range(.2,.28))

#define step
if wep = "perpetrator" && bwep != "undulator"
{
	if !irandom(1){with instance_create(x,y,Curse){sprite_index = global.sprDual;image_blend = c_black}}
}
