#define init
with Player if race = mod_current create()

#define race_name
return "GUN"

#define race_text
return "SHOOTS"

#define race_mapicon()
with player_find(argument0) if instance_is(wielder, WepPickup) return weapon_get_sprite(weapon)
return mskNone

#define create()
spr_idle = mskNone
spr_walk = mskNone
spr_hurt = mskNone
spr_dead = mskNone
snd_dead = -1
snd_hurt = -1
snd_wrld = -1
snd_cptn = -1
snd_thrn = -1
snd_chst = -1
snd_lowa = -1
snd_lowh = -1
snd_crwn = -1
snd_idpd = -1
snd_spch = -1
image_speed = 0
mask_index = mskNone
canwalk = 0
if instance_is(self, CustomObject) exit
image_alpha = 0
canfire = 0
wielder = -4
weapon = wep
with instance_create(x,y,WepPickup){
    wep = {
        wep : other.wep,
        index : other.index
    } 
    view_object[other.index] = id
    other.wielder = id
}

#define is_mine(w)
return is_object(w) and lq_defget(w, "index", -1) == other.index

#define is_dumb(w)
return w.race = "venuz" or w.race = "skeleton"

#define is_steroids(w)
return w.race = "steroids"

#define reset(w)
if !instance_is(w, Player) exit
if is_dumb(w) or is_steroids(w) w.canspec = 1
w.canfire = 1

#define step
var found = 0
with Player if is_mine(wep){
    other.wielder = id
    found = 1
}
if !found with Player if is_mine(bwep){
    other.wielder = id
    found = 1
}
if !found with ThrownWep if is_mine(wep){
    if other.wielder != id reset(other.wielder)
    other.wielder = id
    found = 1
}
if !found with WepPickup if is_mine(wep){
    if other.wielder != id reset(other.wielder)
    other.wielder = id
    found = 1
}



if instance_is(wielder, Player){
    var w = wielder
    ammo = array_clone(w.ammo)
    reload = w.reload
    my_health = w.my_health
    view_object[index] = w
    if is_mine(w.wep){
        w.canfire = 0
        if is_dumb(w) w.canspec = 0
    }
    else {
        w.canfire = 1
        if is_dumb(w) w.canspec = 1
    }
    if is_steroids(w) {
        if is_mine(w.bwep){
            w.canspec = 0
        }
        else w.canspec = 1
    }
  
}
if instance_is(wielder, WepPickup){
    
}

if button_pressed(index, "fire") or (weapon_get_auto(weapon) and button_check(index, "fire")){
    if instance_is(wielder, Player){
        if is_mine(w.wep){
            if w.can_shoot with w player_fire()
        }
    }
}

if button_pressed(index, "spec"){
    var i = index
    var q = instance_nearest(mouse_x[index], mouse_y[index], WepPickup)
    if instance_exists(q) and q != wielder and point_distance(q.x, q.y, mouse_x[i], mouse_y[i]) < 30{
        wielder.wep = wep
        wielder.canfire = 1
        wielder.canspec = 1
        wep = q.wep
        q.wep = {
            wep : other.wep,
            index : i
        }
        wielder = q
        instance_create(q.x, q.y, Curse)
    }
}


if !instance_exists(wielder) and !instance_exists(GenCont)
    my_health = 0

if instance_exists(wielder){
    view_object[index] = wielder
    x = wielder.x
    y = wielder.y
}

