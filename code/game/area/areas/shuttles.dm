
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Шаттл"
	requires_power = FALSE
	static_lighting = TRUE
	has_gravity = STANDARD_GRAVITY
	always_unpowered = FALSE
	// Loading the same shuttle map at a different time will produce distinct area instances.
	area_flags = NONE
	icon = 'icons/area/areas_station.dmi'
	icon_state = "shuttle"
	flags_1 = CAN_BE_DIRTY_1
	area_limited_icon_smoothing = /area/shuttle
	sound_environment = SOUND_ENVIRONMENT_ROOM


/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Multi-area shuttles////////////////////////////

////////////////////////////Syndicate infiltrator////////////////////////////

/area/shuttle/syndicate
	name = "Лазутчик Синдиката"
	ambience_index = AMBIENCE_DANGER
	area_limited_icon_smoothing = /area/shuttle/syndicate

/area/shuttle/syndicate/bridge
	name = "Лазутчик Синдиката: Мостик"

/area/shuttle/syndicate/medical
	name = "Лазутчик Синдиката: Медбей"

/area/shuttle/syndicate/armory
	name = "Лазутчик Синдиката: Арсенал"

/area/shuttle/syndicate/eva
	name = "Лазутчик Синдиката: ЕВА"

/area/shuttle/syndicate/hallway
	name = "Лазутчик Синдиката: Шлюз"

/area/shuttle/syndicate/engineering
	name = "Лазутчик Синдиката: Инженерка"

/area/shuttle/syndicate/airlock
	name = "Лазутчик Синдиката: Шлюз"

////////////////////////////Pirate Shuttle////////////////////////////

/area/shuttle/pirate
	name = "Пиратский шаттл"
	requires_power = TRUE

/area/shuttle/pirate/flying_dutchman
	name = "Flying Dutchman"
	requires_power = FALSE

////////////////////////////Bounty Hunter Shuttles////////////////////////////

/area/shuttle/hunter
	name = "Охотник"

/area/shuttle/hunter/russian
	name = "Русский грузовой шаттл"
	requires_power = TRUE

////////////////////////////White Ship////////////////////////////

/area/shuttle/abandoned
	name = "Забытый корабль"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/abandoned

/area/shuttle/abandoned/bridge
	name = "Забытый корабль: Мостик"

/area/shuttle/abandoned/engine
	name = "Забытый корабль: Двигатель"

/area/shuttle/abandoned/bar
	name = "Забытый корабль: Бар"

/area/shuttle/abandoned/crew
	name = "Забытый корабль: Каюты"

/area/shuttle/abandoned/cargo
	name = "Забытый корабль: Карго"

/area/shuttle/abandoned/medbay
	name = "Забытый корабль: Медбей"

/area/shuttle/abandoned/pod
	name = "Забытый корабль: Под"

////////////////////////////Single-area shuttles////////////////////////////
/area/shuttle/transit
	name = "Гиперпространство"
	desc = "Уииииииииииии"
	static_lighting = FALSE
	base_lighting_alpha = 255


/area/shuttle/arrival
	name = "Шаттл прибытия"
	area_flags = UNIQUE_AREA// SSjob refers to this area for latejoiners


/area/shuttle/arrival/on_joining_game(mob/living/boarder)
	if(SSshuttle.arrivals?.mode == SHUTTLE_CALL)
		var/atom/movable/screen/splash/Spl = new(null, boarder.client, TRUE)
		Spl.Fade(TRUE)
		boarder.playsound_local(get_turf(boarder), 'sound/voice/ApproachingTG.ogg', 25)
	boarder.update_parallax_teleport()


/area/shuttle/pod_1
	name = "Под: Первый"
	area_flags = NONE

/area/shuttle/pod_2
	name = "Под: Второй"
	area_flags = NONE

/area/shuttle/pod_3
	name = "Под: Третий"
	area_flags = NONE

/area/shuttle/pod_4
	name = "Под: Четвёртый"
	area_flags = NONE

/area/shuttle/mining
	name = "Шахтёрский шаттл"

/area/shuttle/mining/large
	name = "Шахтёрский шаттл"
	requires_power = TRUE

/area/shuttle/labor
	name = "Шаттл каторги"

/area/shuttle/supply
	name = "Шаттл снабжения"
	area_flags = NOTELEPORT

/area/shuttle/escape
	name = "Эвакуационный шаттл"
	area_flags = BLOBS_ALLOWED
	area_limited_icon_smoothing = /area/shuttle/escape
	flags_1 = CAN_BE_DIRTY_1
	area_flags = CULT_PERMITTED

/area/shuttle/escape/backup
	name = "Запасной эвакуационный шаттл"

/area/shuttle/escape/brig
	name = "Бриг эвакуационного шаттла"
	icon_state = "shuttlered"

/area/shuttle/escape/luxury
	name = "Роскошный эвакуационный шаттл"
	area_flags = NOTELEPORT

/area/shuttle/escape/simulation
	name = "Симулятор средневековья"
	icon_state = "shuttlectf"
	area_flags = NOTELEPORT
	static_lighting = FALSE
	base_lighting_alpha = 255

/area/shuttle/escape/arena
	name = "Арена"
	area_flags = NOTELEPORT

/area/shuttle/escape/meteor
	name = "метеор с движками"
	luminosity = NONE

/area/shuttle/escape/engine
	name = "Escape Shuttle Engine"

/area/shuttle/transport
	name = "Транспортный шаттл"

/area/shuttle/assault_pod
	name = "Стальной дождь"

/area/shuttle/sbc_starfury
	name = "SBC Звездная ярость"

/area/shuttle/sbc_fighter1
	name = "SBC Боец 1"

/area/shuttle/sbc_fighter2
	name = "SBC Боец 2"

/area/shuttle/sbc_fighter3
	name = "SBC Боец 3"

/area/shuttle/sbc_corvette
	name = "SBC корвет"

/area/shuttle/syndicate_scout
	name = "Разведчик Синдиката"

/area/shuttle/ruin
	name = "Ruined Shuttle"

/// Special shuttles made for the Caravan Ambush ruin.
/area/shuttle/ruin/caravan
	requires_power = TRUE
	name = "Ruined Caravan Shuttle"

/area/shuttle/ruin/caravan/syndicate1
	name = "Боец Синдиката 1"

/area/shuttle/ruin/caravan/syndicate2
	name = "Боец Синдиката 2"

/area/shuttle/ruin/caravan/syndicate3
	name = "Десантный корабль синдиката"

/area/shuttle/ruin/caravan/pirate
	name = "Пиратский резак"

/area/shuttle/ruin/caravan/freighter1
	name = "Малый грузовой корабль"

/area/shuttle/ruin/caravan/freighter2
	name = "Крошечный грузовой корабль"

/area/shuttle/ruin/caravan/freighter3
	name = "Крошечный грузовой корабль"

// ----------- Cyborg Mothership

/area/shuttle/ruin/cyborg_mothership
	name = "Cyborg Mothership"
	requires_power = TRUE
	area_limited_icon_smoothing = /area/shuttle/ruin/cyborg_mothership

// ----------- Arena Shuttle
/area/shuttle/shuttle_arena
	name = "arena"
	has_gravity = STANDARD_GRAVITY
	requires_power = FALSE

/obj/effect/forcefield/arena_shuttle
	name = "portal"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle/Initialize(mapload)
	. = ..()
	for(var/obj/effect/landmark/shuttle_arena_safe/exit in GLOB.landmarks_list)
		warp_points += exit

/obj/effect/forcefield/arena_shuttle/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if(L.pulling && istype(L.pulling, /obj/item/bodypart/head))
		to_chat(L, span_notice("Your offering is accepted. You may pass."), confidential = TRUE)
		qdel(L.pulling)
		var/turf/LA = get_turf(pick(warp_points))
		L.forceMove(LA)
		L.remove_status_effect(/datum/status_effect/hallucination)
		to_chat(L, "<span class='reallybig redtext'>The battle is won. Your bloodlust subsides.</span>", confidential = TRUE)
		for(var/obj/item/chainsaw/doomslayer/chainsaw in L)
			qdel(chainsaw)
		var/obj/item/skeleton_key/key = new(L)
		L.put_in_hands(key)
	else
		to_chat(L, span_warning("You are not yet worthy of passing. Drag a severed head to the barrier to be allowed entry to the hall of champions."), confidential = TRUE)

/obj/effect/landmark/shuttle_arena_safe
	name = "зал чемпионов"
	desc = "Для победителей."

/obj/effect/landmark/shuttle_arena_entrance
	name = "арена"
	desc = "Поле боя, заполненное лавой."

/obj/effect/forcefield/arena_shuttle_entrance
	name = "portal"
	initial_duration = 0
	var/list/warp_points = list()

/obj/effect/forcefield/arena_shuttle_entrance/Bumped(atom/movable/AM)
	if(!isliving(AM))
		return

	if(!warp_points.len)
		for(var/obj/effect/landmark/shuttle_arena_entrance/S in GLOB.landmarks_list)
			warp_points |= S

	var/obj/effect/landmark/LA = pick(warp_points)
	var/mob/living/M = AM
	M.forceMove(get_turf(LA))
	to_chat(M, "<span class='reallybig redtext'>You're trapped in a deadly arena! To escape, you'll need to drag a severed head to the escape portals.</span>", confidential = TRUE)
	M.apply_status_effect(/datum/status_effect/mayhem)
