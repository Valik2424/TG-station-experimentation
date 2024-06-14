/datum/smite/scare
	name = "Scare"

/datum/smite/scare/proc/get_random_sound()
	var/sounds = list(
		'white/master/sound/effects/scream1.ogg',
		'white/master/sound/effects/scream2.ogg',
		'white/master/sound/effects/scream3.ogg',
		'white/master/sound/effects/scream4.ogg',
		'white/master/sound/effects/scream5.ogg',
		'white/master/sound/effects/scream6.ogg',
		'white/master/sound/effects/scream7.ogg',
		'white/master/sound/effects/scream8.ogg',
		'white/master/sound/effects/scream9.ogg',
		'white/master/sound/effects/scream10.ogg'
	)

	return pick(sounds)

/atom/movable/screen/fullscreen/screamer
	icon = 'white/valtos/icons/ruzone_went_up.dmi'
	plane = SPLASHSCREEN_PLANE
	screen_loc = "CENTER-7,SOUTH"
	icon_state = ""

/datum/smite/scare/proc/clear_efffects(mob/living/target)
	if (!target.client)
		return

	if (!target.hud_used)
		return

	var/list/screens = list(target.hud_used.get_plane_master(FLOOR_PLANE), target.hud_used.get_plane_master(GAME_PLANE), target.hud_used.get_plane_master(LIGHTING_PLANE))

	for (var/atom/movable/screen/plane_master/whole_screen in screens)
		animate(whole_screen, transform = matrix(), pixel_x = 0, pixel_y = 0, color = "#ffffff", time = 10, easing = ELASTIC_EASING)
		addtimer(VARSET_CALLBACK(whole_screen, filters, list()), 10) //reset filters

/datum/smite/scare/effect(client/user, mob/living/target)
	. = ..()
	if(!isliving(target))
		to_chat(user, span_warning("Это можно использовать только на /mob/living."), confidential = TRUE)
		return

	var/mob/living/dude = target
	to_chat(dude, span_danger("БУ!"))

	var/list/screens = list(dude.hud_used.get_plane_master(FLOOR_PLANE), dude.hud_used.get_plane_master(GAME_PLANE), dude.hud_used.get_plane_master(LIGHTING_PLANE))
	for(var/atom/movable/screen/plane_master/whole_screen in screens)
		dude.overlay_fullscreen("screamer", /atom/movable/screen/fullscreen/screamer, rand(1, 23))
		animate(whole_screen, transform = matrix()*2, time = 40, easing = BOUNCE_EASING)
		dude.clear_fullscreen("screamer", rand(15, 60))

	dude.playsound_local(dude, get_random_sound(), 100)
	dude.emote("scream")

	addtimer(CALLBACK(src, PROC_REF(clear_efffects), dude), 60)

/obj/item/melee/baton/scare
	name = "полицейская дубинка"
	desc = "Деревянная дубинка для ломания позвоничника. Левый клик - оглушение, правый - ломание."

/obj/item/melee/baton/scare/attack(mob/living/target, mob/living/user, params)
	. = ..()

	if (!check_rights(R_FUN))
		return

	if (HAS_TRAIT(target, TRAIT_IWASBATONED))
		return

	var/datum/smite/smite = new /datum/smite/scare
	var/configuration_success = smite.configure(usr)
	if (configuration_success == FALSE)
		return

	smite.effect(src, target)


/obj/item/melee/baton/scare/proc/punish_log(whom, punishment)
	return
