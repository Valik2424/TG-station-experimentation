#define AQUARIUM_LAYER_STEP 0.01
/// Aquarium content layer offsets
#define AQUARIUM_MIN_OFFSET 0.01
#define AQUARIUM_MAX_OFFSET 1

/obj/structure/aquarium
	name = "аквариум"
	desc = "В аквариуме содержится водная фауна и флора."
	density = TRUE
	anchored = TRUE

	icon = 'icons/obj/aquarium.dmi'
	icon_state = "aquarium_base"

	integrity_failure = 0.3

	var/fluid_type = AQUARIUM_FLUID_FRESHWATER
	var/fluid_temp = DEFAULT_AQUARIUM_TEMP
	var/min_fluid_temp = MIN_AQUARIUM_TEMP
	var/max_fluid_temp = MAX_AQUARIUM_TEMP

	///While the feed storage is not empty, this is the interval which the fish are fed.
	var/feeding_interval = 3 MINUTES
	///The last time fishes were fed by the acquarium itsef.
	var/last_feeding

	/// Can fish reproduce in this quarium.
	var/allow_breeding = FALSE

	var/glass_icon_state = "aquarium_glass"
	var/broken_glass_icon_state = "aquarium_glass_broken"

	//This is the area where fish can swim
	var/aquarium_zone_min_px = 2
	var/aquarium_zone_max_px = 31
	var/aquarium_zone_min_py = 10
	var/aquarium_zone_max_py = 24

	var/list/fluid_types = list(AQUARIUM_FLUID_SALTWATER, AQUARIUM_FLUID_FRESHWATER, AQUARIUM_FLUID_SULPHWATEVER, AQUARIUM_FLUID_AIR)

	var/panel_open = TRUE

	///Current layers in use by aquarium contents
	var/list/used_layers = list()

	/// /obj/item/fish in the aquarium, sorted by type - does not include things with aquarium visuals that are not fish
	var/list/tracked_fish_by_type

/obj/structure/aquarium/Initialize(mapload)
	. = ..()
	update_appearance()
	RegisterSignal(src, COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON, PROC_REF(track_if_fish))
	AddElement(/datum/element/relay_attackers)
	RegisterSignal(src, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_attacked))
	create_reagents(6, SEALED_CONTAINER)
	RegisterSignal(reagents, COMSIG_REAGENTS_NEW_REAGENT, PROC_REF(start_autofeed))
	AddComponent(/datum/component/plumbing/aquarium)

/obj/structure/aquarium/proc/track_if_fish(atom/source, atom/initialized)
	SIGNAL_HANDLER
	if(isfish(initialized))
		LAZYADDASSOCLIST(tracked_fish_by_type, initialized.type, initialized)

/obj/structure/aquarium/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(isfish(arrived))
		LAZYADDASSOCLIST(tracked_fish_by_type, arrived.type, arrived)

/obj/structure/aquarium/Exited(atom/movable/gone, direction)
	. = ..()
	LAZYREMOVEASSOC(tracked_fish_by_type, gone.type, gone)

/obj/structure/aquarium/proc/start_autofeed(datum/source, new_reagent, amount, reagtemp, data, no_react)
	SIGNAL_HANDLER
	START_PROCESSING(SSobj, src)
	UnregisterSignal(reagents, COMSIG_REAGENTS_NEW_REAGENT)

/obj/structure/aquarium/process(seconds_per_tick)
	if(!reagents.total_volume)
		RegisterSignal(reagents, COMSIG_REAGENTS_NEW_REAGENT, PROC_REF(start_autofeed))
		return PROCESS_KILL
	if(world.time + feeding_interval > last_feeding)
		return
	last_feeding = world.time
	var/list/fishes = get_fishes()
	for(var/obj/item/fish/fish as anything in fishes)
		fish.feed(reagents)

/// Returns tracked_fish_by_type but flattened and without the items in the blacklist, also shuffled if shuffle is TRUE.
/obj/structure/aquarium/proc/get_fishes(shuffle = FALSE, blacklist)
	. = list()
	for(var/fish_type in tracked_fish_by_type)
		. += tracked_fish_by_type[fish_type]
	. -= blacklist
	if(shuffle)
		. = shuffle(.)
	return .

/obj/structure/aquarium/proc/request_layer(layer_type)
	/**
	 * base aq layer
	 * min_offset = this value is returned on bottom layer mode
	 * min_offset + 0.1 fish1
	 * min_offset + 0.2 fish2
	 * ... these layers are returned for auto layer mode and tracked by used_layers
	 * min_offset + max_offset = this value is returned for top layer mode
	 * min_offset + max_offset + 1 = this is used for glass overlay
	 */
	//optional todo: hook up sending surface changed on aquarium changing layers
	switch(layer_type)
		if(AQUARIUM_LAYER_MODE_BOTTOM)
			return layer + AQUARIUM_MIN_OFFSET
		if(AQUARIUM_LAYER_MODE_TOP)
			return layer + AQUARIUM_MAX_OFFSET
		if(AQUARIUM_LAYER_MODE_AUTO)
			var/chosen_layer = layer + AQUARIUM_MIN_OFFSET + AQUARIUM_LAYER_STEP
			while((chosen_layer in used_layers) && (chosen_layer <= layer + AQUARIUM_MAX_OFFSET))
				chosen_layer += AQUARIUM_LAYER_STEP
			used_layers += chosen_layer
			return chosen_layer

/obj/structure/aquarium/proc/free_layer(value)
	used_layers -= value

/obj/structure/aquarium/proc/get_surface_properties()
	. = list()
	.[AQUARIUM_PROPERTIES_PX_MIN] = aquarium_zone_min_px
	.[AQUARIUM_PROPERTIES_PX_MAX] = aquarium_zone_max_px
	.[AQUARIUM_PROPERTIES_PY_MIN] = aquarium_zone_min_py
	.[AQUARIUM_PROPERTIES_PY_MAX] = aquarium_zone_max_py

/obj/structure/aquarium/update_overlays()
	. = ..()
	if(panel_open)
		. += "panel"

	//Glass overlay goes on top of everything else.
	var/mutable_appearance/glass_overlay = mutable_appearance(icon,broken ? broken_glass_icon_state : glass_icon_state,layer=AQUARIUM_MAX_OFFSET-1)
	. += glass_overlay

/obj/structure/aquarium/examine(mob/user)
	. = ..()
	. += span_notice("<b>Alt-клик</b> для [panel_open ? "закрытия" : "открытия"] панели управления.")
	if(panel_open && reagents.total_volume)
		. += span_notice("Можно использовать вантуз для опорожнения хранилища корма.")

/obj/structure/aquarium/AltClick(mob/living/user)
	. = ..()
	if(!user.can_perform_action(src))
		return
	panel_open = !panel_open
	balloon_alert(user, "панель [panel_open ? "открыта" : "закрыта"]")
	if(panel_open)
		reagents.flags |= TRANSPARENT|REFILLABLE
	else
		reagents.flags &= ~(TRANSPARENT|REFILLABLE)
	update_appearance()

/obj/structure/aquarium/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	return TOOL_ACT_TOOLTYPE_SUCCESS

/obj/structure/aquarium/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	if(!panel_open)
		return
	to_chat(user, span_notice("Начинаю опорожнять [name]."))
	if(do_after(user, 3 SECONDS, target = src))
		to_chat(user, span_notice("Закончиваю опоржнять [name]."))
		reagents.expose(get_turf(src), TOUCH) //splash on the floor
		reagents.clear_reagents()

/obj/structure/aquarium/attackby(obj/item/item, mob/living/user, params)
	if(broken)
		var/obj/item/stack/sheet/glass/glass = item
		if(istype(glass))
			if(glass.get_amount() < 2)
				to_chat(user, span_warning("Мне понадобятся два листа стекла, чтобы починить корпус!"))
				return
			to_chat(user, span_notice("Начинаю ремонтировать [src]..."))
			if(do_after(user, 2 SECONDS, target = src))
				glass.use(2)
				broken = FALSE
				atom_integrity = max_integrity
				update_appearance()
			return TRUE
	else
		var/datum/component/aquarium_content/content_component = item.GetComponent(/datum/component/aquarium_content)
		if(content_component && content_component.is_ready_to_insert(src) && user.transferItemToLoc(item, src))
			update_appearance()
			return TRUE

	if(istype(item, /obj/item/fish_feed) && !panel_open)
		if(!item.reagents.total_volume)
			balloon_alert(user, "[item] пустой!")
			return TRUE
		var/list/fishes = get_fishes()
		for(var/obj/item/fish/fish as anything in fishes)
			fish.feed(item.reagents)
		balloon_alert(user, "покормил рыбок")
		return TRUE
	return ..()

/obj/structure/aquarium/proc/on_attacked(datum/source, mob/attacker, attack_flags)
	var/list/fishes = get_fishes()
	//I wish this were an aquarium signal, but the aquarium_content component got in the way.
	for(var/obj/item/fish/fish as anything in fishes)
		SEND_SIGNAL(fish, COMSIG_FISH_STIRRED)

/obj/structure/aquarium/interact(mob/user)
	if(!broken && user.pulling && isliving(user.pulling))
		var/mob/living/living_pulled = user.pulling
		var/datum/component/aquarium_content/content_component = living_pulled.GetComponent(/datum/component/aquarium_content)
		if(content_component && content_component.is_ready_to_insert(src))
			try_to_put_mob_in(user)
	else if(panel_open)
		. = ..() //call base ui_interact
	else
		admire(user)

/// Tries to put mob pulled by the user in the aquarium after a delay
/obj/structure/aquarium/proc/try_to_put_mob_in(mob/user)
	if(user.pulling && isliving(user.pulling))
		var/mob/living/living_pulled = user.pulling
		if(living_pulled.buckled || living_pulled.has_buckled_mobs())
			to_chat(user, span_warning("[living_pulled] прилипла к чему-то!"))
			return
		user.visible_message(span_danger("[user] начинает запускать [living_pulled] в [src]!"))
		if(do_after(user, 10 SECONDS, target = src))
			if(QDELETED(living_pulled) || user.pulling != living_pulled || living_pulled.buckled || living_pulled.has_buckled_mobs())
				return
			var/datum/component/aquarium_content/content_component = living_pulled.GetComponent(/datum/component/aquarium_content)
			if(content_component || content_component.is_ready_to_insert(src))
				return
			user.visible_message(span_danger("[user] выпускает [living_pulled] в [src]!"))
			living_pulled.forceMove(src)
			update_appearance()

///Apply mood bonus depending on aquarium status
/obj/structure/aquarium/proc/admire(mob/living/user)
	to_chat(user,span_notice("Нахожу минутку, чтобы понаблюдать за [src]."))
	if(do_after(user, 5 SECONDS, target = src))
		var/alive_fish = 0
		var/dead_fish = 0
		var/list/tracked_fish = get_fishes()
		for(var/obj/item/fish/fish in tracked_fish)
			if(fish.status == FISH_ALIVE)
				alive_fish++
			else
				dead_fish++
		//Check if there are live fish - good mood
		//All fish dead - bad mood.
		//No fish - nothing.
		if(alive_fish > 0)
			user.add_mood_event("aquarium", /datum/mood_event/aquarium_positive)
		else if(dead_fish > 0)
			user.add_mood_event("aquarium", /datum/mood_event/aquarium_negative)
		// Could maybe scale power of this mood with number/types of fish

/obj/structure/aquarium/ui_data(mob/user)
	. = ..()
	.["fluid_type"] = fluid_type
	.["temperature"] = fluid_temp
	.["allow_breeding"] = allow_breeding
	.["feeding_interval"] = feeding_interval / (1 MINUTES)
	var/list/content_data = list()
	for(var/atom/movable/fish in contents)
		content_data += list(list("name"=fish.name,"ref"=ref(fish)))
	.["contents"] = content_data

/obj/structure/aquarium/ui_static_data(mob/user)
	. = ..()
	//I guess these should depend on the fluid so lava critters can get high or stuff below water freezing point but let's keep it simple for now.
	.["minTemperature"] = min_fluid_temp
	.["maxTemperature"] = max_fluid_temp
	.["fluidTypes"] = fluid_types

/obj/structure/aquarium/ui_act(action, params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	switch(action)
		if("temperature")
			var/temperature = params["temperature"]
			if(isnum(temperature))
				fluid_temp = clamp(temperature, min_fluid_temp, max_fluid_temp)
				. = TRUE
		if("fluid")
			if(params["fluid"] in fluid_types)
				fluid_type = params["fluid"]
				SEND_SIGNAL(src, COMSIG_AQUARIUM_FLUID_CHANGED, fluid_type)
				. = TRUE
		if("allow_breeding")
			allow_breeding = !allow_breeding
			. = TRUE
		if("feeding_interval")
			feeding_interval = params["feeding_interval"] MINUTES
			. = TRUE
		if("remove")
			var/atom/movable/inside = locate(params["ref"]) in contents
			if(inside)
				if(isitem(inside))
					user.put_in_hands(inside)
				else
					inside.forceMove(get_turf(src))
				to_chat(user,span_notice("Вылавливаю [inside] из [src]."))

/obj/structure/aquarium/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Aquarium", name)
		ui.open()

/obj/structure/aquarium/atom_break(damage_flag)
	. = ..()
	if(!broken)
		aquarium_smash()

/obj/structure/aquarium/proc/aquarium_smash()
	broken = TRUE
	var/possible_destinations_for_fish = list()
	var/droploc = drop_location()
	if(isturf(droploc))
		possible_destinations_for_fish = get_adjacent_open_turfs(droploc)
	else
		possible_destinations_for_fish = list(droploc)
	playsound(src, 'sound/effects/glassbr3.ogg', 100, TRUE)
	for(var/atom/movable/fish in contents)
		fish.forceMove(pick(possible_destinations_for_fish))
	if(fluid_type != AQUARIUM_FLUID_AIR)
		var/datum/reagents/reagent_splash = new()
		reagent_splash.add_reagent(/datum/reagent/water, 30)
		chem_splash(droploc, null, 3, list(reagent_splash))
	update_appearance()

#undef AQUARIUM_LAYER_STEP
#undef AQUARIUM_MIN_OFFSET
#undef AQUARIUM_MAX_OFFSET

/obj/structure/aquarium/prefilled/Initialize(mapload)
	. = ..()

	new /obj/item/aquarium_prop/rocks(src)
	new /obj/item/aquarium_prop/seaweed(src)

	new /obj/item/fish/goldfish(src)
	new /obj/item/fish/angelfish(src)
	new /obj/item/fish/guppy(src)

	//They'll be alive for about 30 minutes with this amount.
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 3)
