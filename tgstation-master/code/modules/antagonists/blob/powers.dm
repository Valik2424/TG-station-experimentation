#define BLOB_REROLL_RADIUS 60

/** Simple price check */
/mob/camera/blob/proc/can_buy(cost = 15)
	if(blob_points < cost)
		to_chat(src, span_warning("Не хватает ресурсов, требуется [cost]!"))
		return FALSE
	add_points(-cost)
	return TRUE

/** Places the core itself */
/mob/camera/blob/proc/place_blob_core(placement_override = BLOB_NORMAL_PLACEMENT, pop_override = FALSE)
	if(placed && placement_override != BLOB_FORCE_PLACEMENT)
		return TRUE

	if(placement_override == BLOB_NORMAL_PLACEMENT)
		if(!pop_override && !check_core_visibility())
			return FALSE
		var/turf/placement = get_turf(src)
		if(placement.density)
			to_chat(src, span_warning("Слишком плотное место для установки!"))
			return FALSE
		if(!is_valid_turf(placement))
			to_chat(src, span_warning("Не выходит установить ядро здесь!"))
			return FALSE
		if(!check_objects_tile(placement))
			return FALSE
		if(!pop_override && world.time <= manualplace_min_time && world.time <= autoplace_max_time)
			to_chat(src, span_warning("Слишком рано для установки ядра!"))
			return FALSE
	else
		if(placement_override == BLOB_RANDOM_PLACEMENT)
			var/turf/force_tile = pick(GLOB.blobstart)
			forceMove(force_tile) //got overrided? you're somewhere random, motherfucker

	if(placed && blob_core)
		blob_core.forceMove(loc)
	else
		var/obj/structure/blob/special/core/core = new(get_turf(src), src, 1)
		core.overmind = src
		blobs_legit += src
		blob_core = core
		core.update_appearance()

	update_health_hud()
	placed = TRUE
	announcement_time = world.time + OVERMIND_ANNOUNCEMENT_MAX_TIME

	return TRUE

/** Checks proximity for mobs */
/mob/camera/blob/proc/check_core_visibility()
	for(var/mob/living/player in range(7, src))
		if(ROLE_BLOB in player.faction)
			continue
		if(player.client)
			to_chat(src, span_warning("Кто-то рядом с моим ядром!"))
			return FALSE

	for(var/mob/living/player in view(13, src))
		if(ROLE_BLOB in player.faction)
			continue
		if(player.client)
			to_chat(src, span_warning("Кто-то сможет увидеть ядро здесь!"))
			return FALSE

	return TRUE


/** Checks for previous blobs or denose objects on the tile. */
/mob/camera/blob/proc/check_objects_tile(turf/placement)
	for(var/obj/object in placement)
		if(istype(object, /obj/structure/blob))
			if(istype(object, /obj/structure/blob/normal))
				qdel(object)
			else
				to_chat(src, span_warning("Здесь уже есть масса!"))
				return FALSE
		else
			if(object.density)
				to_chat(src, span_warning("Слишком плотное место для установки!"))
				return FALSE

	return TRUE

/** Moves the core elsewhere. */
/mob/camera/blob/proc/transport_core()
	if(blob_core)
		forceMove(blob_core.drop_location())

/** Jumps to a node */
/mob/camera/blob/proc/jump_to_node()
	if(!length(GLOB.blob_nodes))
		return FALSE

	var/list/nodes = list()
	for(var/index in 1 to length(GLOB.blob_nodes))
		var/obj/structure/blob/special/node/blob = GLOB.blob_nodes[index]
		nodes["Родительская Масса #[index] ([get_area_name(blob)])"] = blob

	var/node_name = tgui_input_list(src, "Куда прыгнем?", "Прыг-скок", nodes)
	if(isnull(node_name) || isnull(nodes[node_name]))
		return FALSE

	var/obj/structure/blob/special/node/chosen_node = nodes[node_name]
	if(chosen_node)
		forceMove(chosen_node.loc)

/** Places important blob structures */
/mob/camera/blob/proc/create_special(price, blobstrain, min_separation, needs_node, turf/tile)
	if(!tile)
		tile = get_turf(src)
	var/obj/structure/blob/blob = (locate(/obj/structure/blob) in tile)
	if(!blob)
		to_chat(src, span_warning("Здесь нет массы!"))
		balloon_alert(src, "здесь нет массы!")
		return FALSE
	if(!istype(blob, /obj/structure/blob/normal))
		to_chat(src, span_warning("Невозможно установить здесь. Нужна обычная масса!"))
		balloon_alert(src, "нужна обычная масса!")
		return FALSE
	if(needs_node)
		var/area/area = get_area(src)
		if(!(area.area_flags & BLOBS_ALLOWED)) //factory and resource blobs must be legit
			to_chat(src, span_warning("Этот тип массы может быть установлен только на станции!"))
			balloon_alert(src, "не могу установить вне станции!")
			return FALSE
		if(nodes_required && !(locate(/obj/structure/blob/special/node) in orange(BLOB_NODE_PULSE_RANGE, tile)) && !(locate(/obj/structure/blob/special/core) in orange(BLOB_CORE_PULSE_RANGE, tile)))
			to_chat(src, span_warning("Эту массу необходимо установить рядом с моим ядром или родительской массой!"))
			balloon_alert(src, "слишком далеко от ядра или родительской массы!")
			return FALSE //handholdotron 2000
	if(min_separation)
		for(var/obj/structure/blob/other_blob in orange(min_separation, tile))
			if(other_blob.type == blobstrain)
				to_chat(src, span_warning("Похожая структура рядом, необходимо установить её на расстоянии  [min_separation] клеток от похожей!"))
				other_blob.balloon_alert(src, "слишком близко!")
				return FALSE
	if(!can_buy(price))
		return FALSE
	var/obj/structure/blob/node = blob.change_to(blobstrain, src)
	return node

/** Toggles requiring nodes */
/mob/camera/blob/proc/toggle_node_req()
	nodes_required = !nodes_required
	if(nodes_required)
		to_chat(src, span_warning("Теперь родительская масса и ядро будут устанавливать прозводящие и ресурсные структуры."))
	else
		to_chat(src, span_warning("Теперь родительская масса и ядро не будут устанавливать прозводящие и ресурсные структуры."))

/** Creates a shield to reflect projectiles */
/mob/camera/blob/proc/create_shield(turf/tile)
	var/obj/structure/blob/shield/shield = locate(/obj/structure/blob/shield) in tile
	if(!shield)
		shield = create_special(BLOB_UPGRADE_STRONG_COST, /obj/structure/blob/shield, 0, FALSE, tile)
		return FALSE

	if(!can_buy(BLOB_UPGRADE_REFLECTOR_COST))
		return FALSE

	if(shield.get_integrity() < shield.max_integrity * 0.5)
		add_points(BLOB_UPGRADE_REFLECTOR_COST)
		to_chat(src, span_warning("Крепкая масса слишком повреждена для модификации!"))
		return FALSE

	to_chat(src, span_warning("Добавляю возможность отражать снаряды, однако структура немного ослаблена."))
	shield = shield.change_to(/obj/structure/blob/shield/reflective, src)

/** Preliminary check before polling ghosts. */
/mob/camera/blob/proc/create_blobbernaut()
	var/turf/current_turf = get_turf(src)
	var/obj/structure/blob/special/factory/factory = locate(/obj/structure/blob/special/factory) in current_turf
	if(!factory)
		to_chat(src, span_warning("Нужно находиться прямо на производящей структуре!"))
		return FALSE
	if(factory.blobbernaut || factory.is_creating_blobbernaut) //if it already made or making a blobbernaut, it can't do it again
		to_chat(src, span_warning("Эта производящая структура уже поддерживает массанаута."))
		return FALSE
	if(factory.get_integrity() < factory.max_integrity * 0.5)
		to_chat(src, span_warning("Эта производящая структура слишком повреждена для массанаута."))
		return FALSE
	if(!can_buy(BLOBMOB_BLOBBERNAUT_RESOURCE_COST))
		return FALSE

	factory.is_creating_blobbernaut = TRUE
	to_chat(src, span_notice("Пытаюсь произвести массанаута."))
	pick_blobbernaut_candidate(factory)

/// Polls ghosts to get a blobbernaut candidate.
/mob/camera/blob/proc/pick_blobbernaut_candidate(obj/structure/blob/special/factory/factory)
	if(isnull(factory))
		return

	var/datum/callback/to_call = CALLBACK(src, PROC_REF(on_poll_concluded), factory)
	factory.AddComponent(/datum/component/orbit_poll, \
		ignore_key = POLL_IGNORE_BLOB, \
		job_bans = ROLE_BLOB, \
		to_call = to_call, \
		title = "Массаунт", \
	)

/// Called when the ghost poll concludes
/mob/camera/blob/proc/on_poll_concluded(obj/structure/blob/special/factory/factory, mob/dead/observer/ghost)
	if(isnull(ghost))
		to_chat(src, span_warning("You could not conjure a sentience for your blobbernaut. Your points have been refunded. Try again later."))
		add_points(BLOBMOB_BLOBBERNAUT_RESOURCE_COST)
		factory.assign_blobbernaut(null)
		return FALSE

	var/mob/living/basic/blob_minion/blobbernaut/minion/blobber = new(get_turf(factory))
	assume_direct_control(blobber)
	factory.assign_blobbernaut(blobber)
	blobber.assign_key(ghost.key, blobstrain)
	RegisterSignal(blobber, COMSIG_HOSTILE_POST_ATTACKINGTARGET, PROC_REF(on_blobbernaut_attacked))

/// When one of our boys attacked something, we sometimes want to perform extra effects
/mob/camera/blob/proc/on_blobbernaut_attacked(mob/living/basic/blobbynaut, atom/target, success)
	SIGNAL_HANDLER
	if (!success)
		return
	blobstrain.blobbernaut_attack(target, blobbynaut)

/** Moves the core */
/mob/camera/blob/proc/relocate_core()
	var/turf/tile = get_turf(src)
	var/obj/structure/blob/special/node/blob = locate(/obj/structure/blob/special/node) in tile

	if(!blob)
		to_chat(src, span_warning("Надо быть на массе!"))
		return FALSE

	if(!blob_core)
		to_chat(src, span_userdanger("У меня нет ядра и я скоро умру! Пиздец."))
		return FALSE

	var/area/area = get_area(tile)
	if(isspaceturf(tile) || area && !(area.area_flags & BLOBS_ALLOWED))
		to_chat(src, span_warning("Не могу переместить сюда свое ядро!"))
		return FALSE

	if(!can_buy(BLOB_POWER_RELOCATE_COST))
		return FALSE

	var/turf/old_turf = get_turf(blob_core)
	var/old_dir = blob_core.dir
	blob_core.forceMove(tile)
	blob_core.setDir(blob.dir)
	blob.forceMove(old_turf)
	blob.setDir(old_dir)

/** Searches the tile for a blob and removes it. */
/mob/camera/blob/proc/remove_blob(turf/tile)
	var/obj/structure/blob/blob = locate() in tile

	if(!blob)
		to_chat(src, span_warning("Здесь нет массы!"))
		return FALSE

	if(blob.point_return < 0)
		to_chat(src, span_warning("Невозможно удалить эту массу."))
		return FALSE

	if(max_blob_points < blob.point_return + blob_points)
		to_chat(src, span_warning("Ресурсов слишком много!"))
		return FALSE

	if(blob.point_return)
		add_points(blob.point_return)
		to_chat(src, span_notice("Получили [blob.point_return] ресурсов благодаря удалению [blob]."))

	qdel(blob)

	return TRUE

/** Expands to nearby tiles */
/mob/camera/blob/proc/expand_blob(turf/tile)
	if(world.time < last_attack)
		return FALSE
	var/list/possible_blobs = list()

	for(var/obj/structure/blob/blob in range(tile, 1))
		possible_blobs += blob

	if(!length(possible_blobs))
		to_chat(src, span_warning("Здесь нет массы рядом!"))
		return FALSE

	if(!can_buy(BLOB_EXPAND_COST))
		return FALSE

	var/attack_success
	for(var/mob/living/player in tile)
		if(!player.can_blob_attack())
			continue
		if(ROLE_BLOB in player.faction) //no friendly/dead fire
			continue
		if(player.stat != DEAD)
			attack_success = TRUE
		blobstrain.attack_living(player, possible_blobs)

	var/obj/structure/blob/blob = locate() in tile

	if(blob)
		if(attack_success) //if we successfully attacked a turf with a blob on it, only give an attack refund
			blob.blob_attack_animation(tile, src)
			add_points(BLOB_ATTACK_REFUND)
		else
			to_chat(src, span_warning("Здесь уже есть масса!"))
			add_points(BLOB_EXPAND_COST) //otherwise, refund all of the cost
	else
		directional_attack(tile, possible_blobs, attack_success)

	if(attack_success)
		last_attack = world.time + CLICK_CD_MELEE
	else
		last_attack = world.time + CLICK_CD_RAPID


/** Finds cardinal and diagonal attack directions */
/mob/camera/blob/proc/directional_attack(turf/tile, list/possible_blobs, attack_success = FALSE)
	var/list/cardinal_blobs = list()
	var/list/diagonal_blobs = list()

	for(var/obj/structure/blob/blob in possible_blobs)
		if(get_dir(blob, tile) in GLOB.cardinals)
			cardinal_blobs += blob
		else
			diagonal_blobs += blob

	var/obj/structure/blob/attacker
	if(length(cardinal_blobs))
		attacker = pick(cardinal_blobs)
		if(!attacker.expand(tile, src))
			add_points(BLOB_ATTACK_REFUND) //assume it's attacked SOMETHING, possibly a structure
	else
		attacker = pick(diagonal_blobs)
		if(attack_success)
			attacker.blob_attack_animation(tile, src)
			playsound(attacker, 'sound/effects/splat.ogg', 50, TRUE)
			add_points(BLOB_ATTACK_REFUND)
		else
			add_points(BLOB_EXPAND_COST) //if we're attacking diagonally and didn't hit anything, refund
	return TRUE

/** Rally spores to a location */
/mob/camera/blob/proc/rally_spores(turf/tile)
	to_chat(src, "Направляю споры.")
	var/list/surrounding_turfs = TURF_NEIGHBORS(tile)
	if(!length(surrounding_turfs))
		return FALSE
	for(var/mob/living/basic/blob_mob as anything in blob_mobs)
		if(!isturf(blob_mob.loc) || get_dist(blob_mob, tile) > 35 || blob_mob.key)
			continue
		blob_mob.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		blob_mob.ai_controller.set_blackboard_key(BB_TRAVEL_DESTINATION, pick(surrounding_turfs))

/** Opens the reroll menu to change strains */
/mob/camera/blob/proc/strain_reroll()
	if (!free_strain_rerolls && blob_points < BLOB_POWER_REROLL_COST)
		to_chat(src, span_warning("Требуется [BLOB_POWER_REROLL_COST] ресурсов для перестроения структуры!"))
		return FALSE

	open_reroll_menu()

/** Controls changing strains */
/mob/camera/blob/proc/open_reroll_menu()
	if (!strain_choices)
		strain_choices = list()

		var/list/new_strains = GLOB.valid_blobstrains.Copy() - blobstrain.type
		for (var/unused in 1 to BLOB_POWER_REROLL_CHOICES)
			var/datum/blobstrain/strain = pick_n_take(new_strains)

			var/image/strain_icon = image('icons/mob/nonhuman-player/blob.dmi', "blob_core")
			strain_icon.color = initial(strain.color)

			var/info_text = span_boldnotice("[initial(strain.name)]")
			info_text += "<br>[span_notice("[initial(strain.analyzerdescdamage)]")]"
			if (!isnull(initial(strain.analyzerdesceffect)))
				info_text += "<br>[span_notice("[initial(strain.analyzerdesceffect)]")]"

			var/datum/radial_menu_choice/choice = new
			choice.image = strain_icon
			choice.info = info_text

			strain_choices[initial(strain.name)] = choice

	var/strain_result = show_radial_menu(src, src, strain_choices, radius = BLOB_REROLL_RADIUS, tooltips = TRUE)
	if (isnull(strain_result))
		return

	if (!free_strain_rerolls && !can_buy(BLOB_POWER_REROLL_COST))
		return

	for (var/_other_strain in GLOB.valid_blobstrains)
		var/datum/blobstrain/other_strain = _other_strain
		if (initial(other_strain.name) == strain_result)
			set_strain(other_strain)

			if (free_strain_rerolls)
				free_strain_rerolls -= 1

			last_reroll_time = world.time
			strain_choices = null

			return

#undef BLOB_REROLL_RADIUS
