/datum/map_generator/station_maints_generator
	var/name = "Техтоннели"
	var/list/turf_types = list(/turf/open/floor/plating = 90, /turf/open/floor/iron = 1, /turf/open/floor/iron/dark = 1, /turf/closed/wall = 1)
	var/list/garbage_types = list(
		/obj/effect/spawner/random/trash/grille_or_waste = 50,
		/obj/structure/grille = 80,
		/obj/structure/girder = 5,
		/obj/structure/grille/broken = 10,
		/obj/item/shard = 10,
		/obj/effect/spawner/random/entertainment/drugs = 1,
		/obj/effect/spawner/random/food_or_drink/refreshing_beverage = 1,
		/obj/effect/spawner/random/trash/botanical_waste = 25,
		/obj/effect/spawner/random/trash/cigbutt = 25,
		/obj/effect/spawner/random/trash/garbage = 25,
		/obj/effect/spawner/random/entertainment/gambling = 1,
		/obj/effect/spawner/random/contraband/prison = 1,
		/obj/effect/spawner/random/maintenance = 1,
		/obj/effect/spawner/random/maintenance/two = 1,
		/obj/effect/spawner/random/maintenance/three = 1,
		/obj/effect/spawner/random/maintenance/four = 1,
		/obj/effect/spawner/random/maintenance/five = 1,
		/obj/effect/spawner/random/maintenance/six = 1,
		/obj/effect/spawner/random/maintenance/seven = 1,
		/obj/effect/spawner/random/maintenance/eight = 1,
		/obj/effect/spawner/random/medical/two_percent_xeno_egg_spawner = 1,
		/obj/effect/spawner/random/clothing/costume  = 1,
		/obj/effect/gibspawner/generic = 1,
		/obj/effect/spawner/structure/window/hollow = 5,
		/obj/effect/spawner/random/trash/mess = 25,
		/mob/living/basic/spider/giant = 1,
		/mob/living/basic/cockroach = 1,
		/obj/effect/spawner/random/exotic/languagebook = 1,
		/obj/effect/spawner/random/engineering/tool_advanced = 1,
		/obj/effect/spawner/random/medical/surgery_tool_alien = 1,
		/obj/effect/spawner/random/medical/surgery_tool_advanced = 1,
		/obj/effect/spawner/random/exotic/technology = 1,
		/obj/effect/spawner/random/entertainment/money_large = 1,
		/obj/effect/spawner/random/engineering/material_rare = 1,
		/obj/effect/spawner/random/exotic/syndie = 1,
		/obj/effect/spawner/random/decoration/material = 1,
		/obj/structure/trash_pile = 3
	)

	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_garbage_chance = 45

	///Amount of smoothing iterations
	var/smoothing_iterations = 20

	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4

	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/area/station/maintenance/bottom_station_maints
	name = "Центральные техтоннели"
	icon_state = "bottommaint"
	area_flags = UNIQUE_AREA | FLORA_ALLOWED | MOB_SPAWN_ALLOWED | CAVES_ALLOWED | BLOBS_ALLOWED
	map_generator = /datum/map_generator/station_maints_generator

/area/station/maintenance/bottom_station_maints/north
	name = "Низ: Северные техтоннели"

/area/station/maintenance/bottom_station_maints/east
	name = "Низ: Восточные техтоннели"

/area/station/maintenance/bottom_station_maints/west
	name = "Низ: Западные техтоннели"

/area/station/maintenance/bottom_station_maints/south
	name = "Низ: Южные техтоннели"


/datum/map_generator/station_maints_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_garbage_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	// double iterations

	for(var/i in turfs)

		if(!istype(i, /turf/open/genturf))
			continue

		var/turf/gen_turf = i

		var/garbage_turf = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/turf/new_turf = pick_weight(turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, initial(new_turf.baseturfs), CHANGETURF_DEFER_CHANGE)

		if(garbage_turf)
			var/atom/picked_garbage = pick_weight(garbage_types)
			new picked_garbage(new_turf)

		CHECK_TICK

	to_chat(world, span_green(" -- #<b>[name]</b>:> <b>[(REALTIMEOFDAY - start_time)/10]</b> -- "))
	log_world("[name] is done job for [(REALTIMEOFDAY - start_time)/10]s!")
