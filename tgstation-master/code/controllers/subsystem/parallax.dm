/// Define for the pickweight value where you get no parallax
#define PARALLAX_NONE "parallax_none"

SUBSYSTEM_DEF(parallax)
	name = "Parallax"
	wait = 2
	flags = SS_POST_FIRE_TIMING | SS_BACKGROUND | SS_NO_INIT
	priority = FIRE_PRIORITY_PARALLAX
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/planet_x_offset = 128
	var/planet_y_offset = 128
	var/atom/movable/screen/parallax_layer/random/random_layer
	var/random_parallax_weights = /atom/movable/screen/parallax_layer/random/space_gas
	var/random_parallax_color
	var/random_space


//These are cached per client so needs to be done asap so people joining at roundstart do not miss these.
/datum/controller/subsystem/parallax/PreInit()
	. = ..()
	random_space = pick(/atom/movable/screen/parallax_layer/layer_1)
	if(prob(70))	//70% chance to pick a special extra layer
		set_random_parallax_layer(random_parallax_weights)
		random_layer = pick(/atom/movable/screen/parallax_layer/random/space_gas)
		random_parallax_color = pick(COLOR_TEAL, COLOR_GREEN, COLOR_SILVER, COLOR_YELLOW, COLOR_CYAN, COLOR_ORANGE, COLOR_PURPLE)//Special color for random_layer1. Has to be done here so everyone sees the same color.
	planet_y_offset = rand(100, 160)
	planet_x_offset = rand(100, 160)



/datum/controller/subsystem/parallax/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(length(currentrun))
		var/client/processing_client = currentrun[currentrun.len]
		currentrun.len--
		if (QDELETED(processing_client) || !processing_client.eye)
			if (MC_TICK_CHECK)
				return
			continue

		var/atom/movable/movable_eye = processing_client.eye
		if(!istype(movable_eye))
			continue

		while(isloc(movable_eye.loc) && !isturf(movable_eye.loc))
			movable_eye = movable_eye.loc
		//get the last movable holding the mobs eye

		if(movable_eye == processing_client.movingmob)
			if (MC_TICK_CHECK)
				return
			continue

		//eye and the last recorded eye are different, and the last recorded eye isnt just the clients mob
		if(!isnull(processing_client.movingmob))
			LAZYREMOVE(processing_client.movingmob.client_mobs_in_contents, processing_client.mob)
		LAZYADD(movable_eye.client_mobs_in_contents, processing_client.mob)

		processing_client.movingmob = movable_eye
		if (MC_TICK_CHECK)
			return
	currentrun = null
/*
............/´¯/)...............(\¯`\
.........../...//.....ЗДОХНИ.....\\...\
........../...//.....ТГКОДЕР.......\\...\
...../´¯/..../´¯\.....ЕБАНЫй...../¯` \....\¯`\
.././.../..../..../.|_......._|.\....\....\...\.\
(.(....(....(..../..)..)…...(..(.\....)....)....).)
.\................\/.../......\...\/................/
..\.................. /.........\................../
*/

/// Generate a random layer for parallax
/datum/controller/subsystem/parallax/proc/set_random_parallax_layer(picked_parallax)
	if(picked_parallax == PARALLAX_NONE)
		return

	random_layer = new picked_parallax(null,  /* hud_owner = */ null, /* template = */ TRUE)
	RegisterSignal(random_layer, COMSIG_QDELETING, PROC_REF(clear_references))

/// Change the random parallax layer after it's already been set. update_player_huds = TRUE will also replace them in the players client images, if it was set
/datum/controller/subsystem/parallax/proc/swap_out_random_parallax_layer(atom/movable/screen/parallax_layer/new_type, update_player_huds = TRUE)
	set_random_parallax_layer(new_type)

	if(!update_player_huds)
		return

	//Parallax is one of the first things to be set (during client join), so rarely is anything fast enough to swap it out
	//That's why we need to swap the layers out for fast joining clients :/
	for(var/client/client as anything in GLOB.clients)
		client.parallax_layers_cached?.Cut()
		client.mob?.hud_used?.update_parallax_pref(client.mob)

/datum/controller/subsystem/parallax/proc/clear_references()
	SIGNAL_HANDLER

	random_layer = null

#undef PARALLAX_NONE

